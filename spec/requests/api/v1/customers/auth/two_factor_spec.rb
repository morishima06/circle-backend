# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'TwoFactorsController', type: :request do
  let!(:customer) { create(:customer, password: 'password123') }

  before do
    get '/api/v1/current_customer'
  end

  let(:csrf_token) { cookies['CSRF-TOKEN'] }

  describe 'GET /api/v1/customers/two_factor' do
    context '2FAセッションが存在しない場合' do
      it '401を返す' do
        get '/api/v1/customers/two_factor'

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'OTPが存在しない場合' do
      before do
        post '/api/v1/customers/login',
             params: {
               customer: {
                 email: customer.email,
                 password: 'password123'
               }
             },
             headers: {
               'X-CSRF-Token' => csrf_token
             }

        Rails.cache.delete("otp:customer:#{customer.id}")
      end

      it '401を返す' do
        get '/api/v1/customers/two_factor'

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context '2FAセッションとOTPが存在する場合' do
      before do
        post '/api/v1/customers/login',
             params: {
               customer: {
                 email: customer.email,
                 password: 'password123'
               }
             },
             headers: {
               'X-CSRF-Token' => csrf_token
             }

        Rails.cache.write(
          "otp:customer:#{customer.id}",
          '123456'
        )
      end

      it '200を返す' do
        get '/api/v1/customers/two_factor'

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'Patch /api/v1/customers/two_factor/verify_otp' do
    context '2FAセッションが存在しない場合' do
      it '401を返す' do
        patch '/api/v1/customers/two_factor/verify_otp',
              params: { otp: '123456' },
              headers: {
                'X-CSRF-Token' => csrf_token
              }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'OTPが存在しない場合' do
      before do
        post '/api/v1/customers/login',
             params: {
               customer: {
                 email: customer.email,
                 password: 'password123'
               }
             },
             headers: {
               'X-CSRF-Token' => csrf_token
             }

        Rails.cache.delete("otp:customer:#{customer.id}")
      end

      it '401を返す' do
        patch '/api/v1/customers/two_factor/verify_otp',
              params: { otp: '123456' },
              headers: {
                'X-CSRF-Token' => csrf_token
              }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'OTPが間違っている場合' do
      before do
        post '/api/v1/customers/login',
             params: {
               customer: {
                 email: customer.email,
                 password: 'password123'
               }
             },
             headers: {
               'X-CSRF-Token' => csrf_token
             }

        Rails.cache.write(
          "otp:customer:#{customer.id}",
          '123456'
        )
      end

      it '422を返す' do
        patch '/api/v1/customers/two_factor/verify_otp',
              params: { otp: '999999' },
              headers: {
                'X-CSRF-Token' => csrf_token
              }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'OTPが正しい場合' do
      before do
        post '/api/v1/customers/login',
             params: {
               customer: {
                 email: customer.email,
                 password: 'password123'
               }
             },
             headers: {
               'X-CSRF-Token' => csrf_token
             }

        Rails.cache.write(
          "otp:customer:#{customer.id}",
          '123456'
        )
        puts "TEST OTP: #{Rails.cache.read("otp:customer:#{customer.id}").inspect}"
      end

      it '204を返す' do
        patch '/api/v1/customers/two_factor/verify_otp',
              params: { otp: '123456' },
              headers: {
                'X-CSRF-Token' => csrf_token
              }

        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
