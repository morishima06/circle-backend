# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Customers::Auth::OmniauthCallbacksController, type: :controller do
  describe 'GET #google_oauth2' do
    context 'Customerが存在しない場合' do
      let(:auth_hash) do
        OmniAuth::AuthHash.new(
          provider: 'google_oauth2',
          uid: '123456789',
          info: {
            email: 'test@gmail.com'
          }
        )
      end

      before do
        request.env['omniauth.auth'] = auth_hash
      end

      it 'Customerを作成する' do
        expect do
          get :google_oauth2
        end.to change(Customer, :count).by(1)

        expect(response).to redirect_to(
          'http://localhost:3000/customer'
        )
      end
    end

    context 'Customerがすでに存在する場合' do
      let!(:customer) { create(:customer, email: 'test@gmail.com') }

      let(:auth_hash) do
        OmniAuth::AuthHash.new(
          provider: 'google_oauth2',
          uid: '123456789',
          info: {
            email: 'test@gmail.com'
          }
        )
      end

      before do
        request.env['omniauth.auth'] = auth_hash
      end

      it '既存のCustomerを使用する' do
        expect do
          get :google_oauth2
        end.not_to change(Customer, :count)

        expect(response).to redirect_to(
          'http://localhost:3000/customer'
        )
      end
    end

    context 'auth_hashが存在しない場合' do
      it 'ログインページにリダイレクトする' do
        get :google_oauth2

        expect(response).to redirect_to(
          'http://localhost:3000/login?error=auth_failed'
        )
      end
    end
  end
end
