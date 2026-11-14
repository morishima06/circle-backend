# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/v1/customers/login', type: :request do
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

  context '2FAが無効の場合' do
    before do
      allow(Customer)
        .to receive(:find_for_authentication)
        .and_return(customer)

      allow(customer)
        .to receive(:two_factor_enabled?)
        .and_return(false)
    end

    it 'ログインに成功し、2FAを要求しない' do
      login

      expect(response).to have_http_status(:ok)

      json = response.parsed_body

      expect(json['requires_2fa']).to eq(false)
    end
  end

  context 'パスワードが間違っている場合' do
    before do
      allow(Customer)
        .to receive(:find_for_authentication)
        .and_return(customer)
    end

    it '422を返す' do
      login(password: 'wrong_password')

      expect(response).to have_http_status(:unprocessable_entity)

      json = response.parsed_body

      expect(json['error']['code']).to eq('validation_failed')
    end
  end

  context 'メールアドレスが存在しない場合' do
    it '422を返す' do
      login(email: 'not_found@example.com')

      expect(response).to have_http_status(:unprocessable_entity)

      json = response.parsed_body

      expect(json['error']['code']).to eq('validation_failed')
    end
  end

  context '2FAが有効で、Trusted Deviceではない場合' do
    before do
      allow(Customer)
        .to receive(:find_for_authentication)
        .and_return(customer)

      allow(customer)
        .to receive(:two_factor_enabled?)
        .and_return(true)

      allow(customer)
        .to receive(:trusted_device_valid?)
        .and_return(false)

      allow(CustomerMailer)
        .to receive_message_chain(:send_otp, :deliver_later)
    end

    it '2FAを要求する' do
      login

      expect(response).to have_http_status(:ok)

      json = response.parsed_body

      expect(json['requires_2fa']).to eq(true)

      expect(session[:pre_2fa_customer_id]).to eq(customer.id)
    end
  end

  context '2FAが有効で、Trusted Deviceの場合' do
    before do
      allow(Customer)
        .to receive(:find_for_authentication)
        .and_return(customer)

      allow(customer)
        .to receive(:two_factor_enabled?)
        .and_return(true)

      allow(customer)
        .to receive(:trusted_device_valid?)
        .and_return(true)
    end

    it '2FAを要求せずログインに成功する' do
      login

      expect(response).to have_http_status(:ok)

      json = response.parsed_body

      expect(json['requires_2fa']).to eq(false)
    end
  end

  describe 'DELETE /api/v1/customers/logout' do
    before do
      allow(Customer)
        .to receive(:find_for_authentication)
        .and_return(customer)

      allow(customer)
        .to receive(:two_factor_enabled?)
        .and_return(false)

      login
    end

    it 'ログアウトに成功する' do
      delete '/api/v1/customers/logout',
             headers: {
               'X-CSRF-Token' => csrf_token
             }

      expect(response).to have_http_status(:no_content)
    end
  end
end
