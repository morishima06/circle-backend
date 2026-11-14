# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/v1/customers/register', type: :request do
  let(:valid_params) do
    {
      customer: {
        email: 'test@example.com',
        password: 'password123',
        password_confirmation: 'password123'
      }
    }
  end

  before do
    get '/api/v1/current_customer'
  end

  let(:csrf_token) { cookies['CSRF-TOKEN'] }

  describe 'POST /api/v1/customers/register' do
    context '登録情報が正しい場合' do
      it 'Customerを作成できる' do
        expect do
          post '/api/v1/customers/register',
               params: valid_params,
               headers: {
                 'X-CSRF-Token' => csrf_token
               }
        end.to change(Customer, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end

    context '登録情報が正しくない場合' do
      it 'Customerを作成できない' do
        invalid_params = {
          customer: {
            email: 'test@example.com',
            password: 'password123',
            password_confirmation: 'wrong'
          }
        }

        expect do
          post '/api/v1/customers/register',
               params: invalid_params,
               headers: {
                 'X-CSRF-Token' => csrf_token
               }
        end.not_to change(Customer, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
