# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Checkout API', type: :request do
  describe 'POST /api/v1/checkout/confirm' do
    before do
      get '/api/v1/current_customer'
    end

    let(:csrf_token) { cookies['CSRF-TOKEN'] }

    context 'ログインユーザーの場合' do
      let(:customer) { create(:customer) }

      let(:order) do
        create(
          :order,
          customer:,
          status: 'pending',
          guest_token: nil
        )
      end

      let!(:order_item) do
        create(
          :order_item,
          order:,
          quantity: 1
        )
      end

      let!(:cart) do
        create(
          :cart,
          customer:,
          guest_token: nil
        )
      end

      let!(:cart_item) do
        create(
          :cart_item,
          cart:,
          sku: order_item.sku,
          quantity: 1
        )
      end

      before do
        allow_any_instance_of(Api::V1::CheckoutController)
          .to receive(:current_order)
          .and_return(order)
      end

      context 'カード決済の場合' do
        let(:payment_intent) do
          double(
            'Stripe::PaymentIntent',
            client_secret: 'test_client_secret'
          )
        end

        it 'PaymentIntentを作成して200を返す' do
          allow(Stripe::CreatePaymentIntentService)
            .to receive(:call)
            .with(order)
            .and_return(payment_intent)

          post '/api/v1/checkout/confirm',
               params: { payment_method: 'card' },
               headers: {
                 'X-CSRF-Token' => csrf_token
               }

          expect(response).to have_http_status(:ok)

          json = response.parsed_body

          expect(json['client_secret']).to eq('test_client_secret')
          expect(json['complete_token']).to eq(order.complete_token)

          expect(Stripe::CreatePaymentIntentService)
            .to have_received(:call)
            .with(order)
        end

        context 'pendingのPaymentが存在する場合' do
          let!(:payment) do
            create(
              :payment,
              order:,
              payment_method: 'card',
              status: 'pending',
              stripe_payment_intent_id: 'pi_test'
            )
          end

          it 'PaymentIntentを更新する' do
            allow(Stripe::UpdatePaymentIntentService)
              .to receive(:call)
              .with('pi_test', order)
              .and_return(payment_intent)

            post '/api/v1/checkout/confirm',
                 params: { payment_method: 'card' },
                 headers: {
                   'X-CSRF-Token' => csrf_token
                 }

            expect(response).to have_http_status(:ok)

            expect(Stripe::UpdatePaymentIntentService)
              .to have_received(:call)
              .with('pi_test', order)
          end
        end
      end

      context '代引きの場合' do
        let(:reserve_service) do
          instance_double(ReserveStocks::ReserveService)
        end

        before do
          allow(ReserveStocks::ReserveService)
            .to receive(:new)
            .with(order)
            .and_return(reserve_service)

          allow(reserve_service)
            .to receive(:call)

          allow(OrderConfirmedMailerJob)
            .to receive(:perform_later)
        end

        it 'Paymentを作成して注文を確定する' do
          expect do
            post '/api/v1/checkout/confirm',
                 params: { payment_method: 'cod' },
                 headers: {
                   'X-CSRF-Token' => csrf_token
                 }
            puts "STATUS: #{response.status}"
  puts "BODY: #{response.body}"

  expect(response).to have_http_status(:ok)
          end.to change(Payment, :count).by(1)

          expect(response).to have_http_status(:ok)

          order.reload

          expect(order.status).to eq('confirmed')

          payment = order.payments.reload.last

          expect(payment.payment_method).to eq('cod')
          expect(payment.status).to eq('unpaid')
        end

        it '在庫確保を実行する' do
          post '/api/v1/checkout/confirm',
               params: { payment_method: 'cod' },
               headers: {
                 'X-CSRF-Token' => csrf_token
               }

          expect(reserve_service)
            .to have_received(:call)
        end

        it '注文確定メールを送信する' do
          post '/api/v1/checkout/confirm',
               params: { payment_method: 'cod' },
               headers: {
                 'X-CSRF-Token' => csrf_token
               }

          expect(OrderConfirmedMailerJob)
            .to have_received(:perform_later)
            .with(order.id)
        end
      end
    end

    context 'ゲストの場合' do
      let(:guest_token) { 'test-guest-token' }

      let(:order) do
        create(
          :order,
          customer: nil,
          status: 'pending',
          guest_token:
        )
      end

      let!(:order_item) do
        create(
          :order_item,
          order:,
          quantity: 1
        )
      end

      let!(:cart) do
        create(
          :cart,
          customer: nil,
          guest_token:
        )
      end

      let!(:cart_item) do
        create(
          :cart_item,
          cart:,
          sku: order_item.sku,
          quantity: 1
        )
      end

      let(:reserve_service) do
        instance_double(ReserveStocks::ReserveService)
      end

      before do
        allow_any_instance_of(Api::V1::CheckoutController)
          .to receive(:current_order)
          .and_return(order)

        allow(ReserveStocks::ReserveService)
          .to receive(:new)
          .with(order)
          .and_return(reserve_service)

        allow(reserve_service)
          .to receive(:call)

        allow(OrderConfirmedMailerJob)
          .to receive(:perform_later)
      end

      context '代引きの場合' do
        it 'Paymentを作成して注文を確定する' do
          expect do
            post '/api/v1/checkout/confirm',
                 params: { payment_method: 'cod' },
                 headers: {
                   'X-CSRF-Token' => csrf_token
                 }
          end.to change(Payment, :count).by(1)

          expect(response).to have_http_status(:ok)

          order.reload

          expect(order.status).to eq('confirmed')

          payment = order.payments.reload.last

          expect(payment.payment_method).to eq('cod')
          expect(payment.status).to eq('unpaid')
        end

        it '在庫確保を実行する' do
          post '/api/v1/checkout/confirm',
               params: { payment_method: 'cod' },
               headers: {
                 'X-CSRF-Token' => csrf_token
               }

          expect(reserve_service)
            .to have_received(:call)
        end

        it '注文確定メールを送信する' do
          post '/api/v1/checkout/confirm',
               params: { payment_method: 'cod' },
               headers: {
                 'X-CSRF-Token' => csrf_token
               }

          expect(OrderConfirmedMailerJob)
            .to have_received(:perform_later)
            .with(order.id)
        end
      end
    end

    context '支払い方法が不正な場合' do
      let(:customer) { create(:customer) }

      let(:order) do
        create(
          :order,
          customer:,
          status: 'pending',
          guest_token: nil
        )
      end

      before do
        allow_any_instance_of(Api::V1::CheckoutController)
          .to receive(:current_order)
          .and_return(order)
      end

      it 'エラーを返す' do
        post '/api/v1/checkout/confirm',
             params: { payment_method: 'invalid' },
             headers: {
               'X-CSRF-Token' => csrf_token
             }

        expect(response).to have_http_status(:unprocessable_entity)

        json = response.parsed_body

        expect(json['error']['code']).to eq('invalid_payment_method')
      end
    end
  end
end
