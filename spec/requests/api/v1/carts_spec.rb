# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Carts API', type: :request do
  let!(:customer) { create(:customer) }

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

  describe 'GET /api/v1/cart' do
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

      context 'カートが存在する場合' do
        let!(:cart) { create(:cart, customer:) }

        it '200を返す' do
          get '/api/v1/cart'

          expect(response).to have_http_status(:ok)
        end
      end

      context 'カートが存在しない場合' do
        it '空のカートを返す' do
          get '/api/v1/cart'

          expect(response).to have_http_status(:ok)
          expect(response.parsed_body['id']).to be_nil
          expect(response.parsed_body['item_count']).to eq(0)
          expect(response.parsed_body['subtotal']).to eq(0)
          expect(response.parsed_body['shipping_fee']).to eq(0)
          expect(response.parsed_body['total']).to eq(0)
          expect(response.parsed_body['currency']).to eq('JPY')
          expect(response.parsed_body['items']).to eq([])
        end
      end
    end

    context 'ゲストの場合' do
      context 'カートが存在する場合' do
        let!(:cart) { create(:cart, guest_token: 'test-token') }

        before do
          cookie_jar = ActionDispatch::Cookies::CookieJar.build(request, {})
          cookie_jar.encrypted[:guest_token] = 'test-token'

          cookies['guest_token'] = cookie_jar[:guest_token]
        end

        it '200を返す' do
          get '/api/v1/cart'

          expect(response).to have_http_status(:ok)
        end
      end

      context 'カートが存在しない場合' do
        it '空のカートを返す' do
          get '/api/v1/cart'

          expect(response).to have_http_status(:ok)
          expect(response.parsed_body['id']).to be_nil
          expect(response.parsed_body['item_count']).to eq(0)
          expect(response.parsed_body['subtotal']).to eq(0)
          expect(response.parsed_body['shipping_fee']).to eq(0)
          expect(response.parsed_body['total']).to eq(0)
          expect(response.parsed_body['currency']).to eq('JPY')
          expect(response.parsed_body['items']).to eq([])
        end
      end
    end
  end
end
