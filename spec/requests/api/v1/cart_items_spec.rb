# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CartItems API', type: :request do
  let!(:customer) { create(:customer) }
  let!(:sku) { create(:sku) }

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

  describe 'POST /api/v1/cart_items' do
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

      it 'カートに商品を追加して200を返す' do
        expect do
          post '/api/v1/cart_items',
               params: {
                 sku_id: sku.id,
                 quantity: 2
               },
               headers: {
                 'X-CSRF-Token' => csrf_token
               }
        end.to change(CartItem, :count).by(1)

        expect(response).to have_http_status(:ok)
      end
    end

    context 'ゲストの場合' do
      it 'カートに商品を追加して200を返す' do
        expect do
          post '/api/v1/cart_items',
               params: {
                 sku_id: sku.id,
                 quantity: 2
               },
               headers: {
                 'X-CSRF-Token' => csrf_token
               }
        end.to change(CartItem, :count).by(1)

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'PATCH /api/v1/cart_items/:sku_id' do
    context 'ログインユーザーの場合' do
      let!(:cart) { create(:cart, customer:) }

      let!(:cart_item) do
        create(
          :cart_item,
          cart:,
          sku:,
          quantity: 1
        )
      end

      before do
        allow(Customer)
          .to receive(:find_for_authentication)
          .and_return(customer)

        allow(customer)
          .to receive(:two_factor_enabled?)
          .and_return(false)

        login
      end

      it '数量を更新して204を返す' do
        patch "/api/v1/cart_items/#{sku.id}",
              params: {
                quantity: 3
              },
              headers: {
                'X-CSRF-Token' => csrf_token
              }

        expect(response).to have_http_status(:no_content)
        expect(cart_item.reload.quantity).to eq(3)
      end
    end

    context 'ゲストの場合' do
      let!(:cart) { create(:cart, guest_token: 'test-token') }

      let!(:cart_item) do
        create(
          :cart_item,
          cart:,
          sku:,
          quantity: 1
        )
      end

      before do
        encrypted_guest_token('test-token')
      end

      it '数量を更新して204を返す' do
        patch "/api/v1/cart_items/#{sku.id}",
              params: {
                quantity: 3
              },
              headers: {
                'X-CSRF-Token' => csrf_token
              }

        expect(response).to have_http_status(:no_content)
        expect(cart_item.reload.quantity).to eq(3)
      end
    end
  end

  describe 'DELETE /api/v1/cart_items/:sku_id' do
    context 'ログインユーザーの場合' do
      let!(:cart) { create(:cart, customer:) }

      let!(:cart_item) do
        create(
          :cart_item,
          cart:,
          sku:,
          quantity: 1
        )
      end

      before do
        allow(Customer)
          .to receive(:find_for_authentication)
          .and_return(customer)

        allow(customer)
          .to receive(:two_factor_enabled?)
          .and_return(false)

        login
      end

      it '商品を削除して204を返す' do
        expect do
          delete "/api/v1/cart_items/#{sku.id}",
                 headers: {
                   'X-CSRF-Token' => csrf_token
                 }
        end.to change(CartItem, :count).by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'ゲストの場合' do
      let!(:cart) { create(:cart, guest_token: 'test-token') }

      let!(:cart_item) do
        create(
          :cart_item,
          cart:,
          sku:,
          quantity: 1
        )
      end

      before do
        encrypted_guest_token('test-token')
      end

      it '商品を削除して204を返す' do
        expect do
          delete "/api/v1/cart_items/#{sku.id}",
                 headers: {
                   'X-CSRF-Token' => csrf_token
                 }
        end.to change(CartItem, :count).by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
