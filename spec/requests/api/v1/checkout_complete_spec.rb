# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Orders API', type: :request do
  describe 'GET /api/v1/orders/complete' do
    context 'ゲストの場合' do
      let(:guest_token) { 'test-guest-token' }

      let!(:order) do
        create(
          :order,
          customer: nil,
          guest_token:,
          customer_type: 'guest',
          status: 'confirmed',
          ordered_at: Time.current,
          number: 'ORD-GUEST-001'
        )
      end

      let!(:payment) do
        create(
          :payment,
          order:,
          payment_method: 'cod',
          status: 'unpaid'
        )
      end

      before do
        order.update!(current_payment: payment)
      end

      context '有効なcomplete_tokenの場合' do
        it '注文情報を返す' do
          get '/api/v1/orders/complete',
              params: { token: order.complete_token }

          expect(response).to have_http_status(:ok)

          json = response.parsed_body

          expect(json['status']).to eq('confirmed')
          expect(json['number']).to eq('ORD-GUEST-001')
          expect(json['payment_method']).to eq('cod')
        end
      end

      context '無効なcomplete_tokenの場合' do
        it '404を返す' do
          get '/api/v1/orders/complete',
              params: { token: 'invalid-token' }

          expect(response).to have_http_status(:not_found)
        end
      end

      context 'complete_tokenがない場合' do
        it '404を返す' do
          get '/api/v1/orders/complete'

          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'ログインユーザーの場合' do
      let!(:customer) { create(:customer) }

      let!(:order) do
        create(
          :order,
          customer:,
          guest_token: nil,
          customer_type: 'customer',
          status: 'confirmed',
          ordered_at: Time.current,
          number: 'ORD-CUSTOMER-001'
        )
      end

      let!(:payment) do
        create(
          :payment,
          order:,
          payment_method: 'cod',
          status: 'unpaid'
        )
      end

      before do
        order.update!(current_payment: payment)
      end

      context '有効なcomplete_tokenの場合' do
        it '注文情報を返す' do
          get '/api/v1/orders/complete',
              params: { token: order.complete_token }

          expect(response).to have_http_status(:ok)

          json = response.parsed_body

          expect(json['status']).to eq('confirmed')
          expect(json['number']).to eq('ORD-CUSTOMER-001')
          expect(json['payment_method']).to eq('cod')
        end
      end

      context '無効なcomplete_tokenの場合' do
        it '404を返す' do
          get '/api/v1/orders/complete',
              params: { token: 'invalid-token' }

          expect(response).to have_http_status(:not_found)
        end
      end

      context 'complete_tokenがない場合' do
        it '404を返す' do
          get '/api/v1/orders/complete'

          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
