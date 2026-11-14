# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Carts::MergeGuestCartService do
  let(:customer) { create(:customer) }
  let(:guest_token) { 'test-guest-token' }

  describe '#call' do
    context 'guest_tokenが空の場合' do
      it '何もしない' do
        expect do
          described_class.new(customer, nil).call
        end.not_to change(Cart, :count)
      end
    end

    context 'guest_tokenに該当するカートが存在しない場合' do
      it '何もしない' do
        expect do
          described_class.new(customer, guest_token).call
        end.not_to change(Cart, :count)
      end
    end

    context 'ゲストカートが存在する場合' do
      let!(:guest_cart) do
        create(
          :cart,
          customer: nil,
          guest_token:
        )
      end

      it 'ゲストカートを顧客のカートに移行する' do
        described_class.new(customer, guest_token).call

        guest_cart.reload

        expect(guest_cart.customer).to eq(customer)
        expect(guest_cart.guest_token).to be_nil
      end

      context '顧客に既存のカートがある場合' do
        let!(:customer_cart) do
          create(
            :cart,
            customer:,
            guest_token: nil
          )
        end

        it '既存のカートを削除してゲストカートを移行する' do
          described_class.new(customer, guest_token).call

          expect(Cart.exists?(customer_cart.id)).to be false

          guest_cart.reload

          expect(guest_cart.customer).to eq(customer)
          expect(guest_cart.guest_token).to be_nil
        end
      end
    end
  end
end
