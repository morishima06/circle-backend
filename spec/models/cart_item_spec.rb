# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartItem, type: :model do
  let(:cart) { create(:cart, guest_token: 'test-guest-token') }
  let(:product) { create(:product, price: 5_000) }
  let(:sku) { create(:sku, product:) }
  let(:cart_item) { create(:cart_item, cart:, sku:, quantity: 2) }

  describe '#update_quantity' do
    it '商品の数量を更新する' do
      cart_item.update_quantity(3)

      expect(cart_item.quantity).to eq(3)
    end
  end

  describe '#subtotal' do
    it '現在の商品価格と数量から小計を計算する' do
      expect(cart_item.subtotal).to eq(10_000)
    end
  end
end
