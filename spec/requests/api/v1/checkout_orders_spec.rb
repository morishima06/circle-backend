# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/v1/orders', type: :request do
  let!(:customer) do
    create(:customer, password: 'password123')
  end

  let!(:cart) do
    create(:cart, customer:)
  end

  let!(:cart_item) do
    create(:cart_item, cart:)
  end

  before do
    get '/api/v1/current_customer'
  end

  let(:csrf_token) { cookies['CSRF-TOKEN'] }

  def login(email: customer.email, password: 'password123')
    post '/api/v1/customers/login',
         params: {
           customer: {
             email:,
             password:
           }
         },
         headers: {
           'X-CSRF-Token' => csrf_token
         }
  end

  def encrypted_guest_token(token)
    cookies = ActionDispatch::Cookies::CookieJar.build(request, {})

    cookies.encrypted[:guest_token] = token

    self.cookies['guest_token'] = cookies[:guest_token]
  end

  describe 'CheckoutでOrderを作成する' do
    context 'ログインユーザーの場合' do
      before do
        allow(Customer)
          .to receive(:find_for_authentication)
          .and_return(customer)

        allow(customer)
          .to receive(:two_factor_enabled?)
          .and_return(false)

        login
      end

      it 'pendingのOrderを作成する' do
        expect do
          post '/api/v1/orders',
               headers: {
                 'X-CSRF-Token' => csrf_token
               }
        end.to change(Order, :count).by(1)

        expect(response).to have_http_status(:ok)

        order = Order.last

        expect(order.customer).to eq(customer)
        expect(order.status).to eq('pending')
        expect(order.email).to eq(customer.email)
        expect(order.expires_at).to be_present
      end

      it '既存のpending Orderを再利用する' do
        existing_order = create(
          :order,
          customer:,
          status: 'pending'
        )

        expect do
          post '/api/v1/orders',
               headers: {
                 'X-CSRF-Token' => csrf_token
               }
        end.not_to change(Order, :count)

        expect(response).to have_http_status(:ok)

        expect(Order.last).to eq(existing_order)
      end
    end

    context 'ゲストユーザーの場合' do
      let!(:cart) do
        create(
          :cart,
          customer: nil,
          guest_token: 'test-guest-token'
        )
      end

      let!(:cart_item) do
        create(:cart_item, cart:)
      end

      before do
        encrypted_guest_token('test-guest-token')
      end

      it 'pendingのOrderを作成する' do
        expect do
          post '/api/v1/orders',
               headers: {
                 'X-CSRF-Token' => csrf_token
               }
        end.to change(Order, :count).by(1)

        expect(response).to have_http_status(:ok)

        order = Order.last

        expect(order.customer).to be_nil
        expect(order.guest_token).to eq('test-guest-token')
        expect(order.status).to eq('pending')
      end

      it '既存のpending Orderを再利用する' do
        existing_order = create(
          :order,
          customer: nil,
          guest_token: 'test-guest-token',
          status: 'pending'
        )

        expect do
          post '/api/v1/orders',
               headers: {
                 'X-CSRF-Token' => csrf_token
               }
        end.not_to change(Order, :count)

        expect(response).to have_http_status(:ok)

        expect(Order.last).to eq(existing_order)
      end
    end
  end
end
