# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cart, type: :model do
  let(:cart) { create(:cart, guest_token: 'test-guest-token') }
  let(:sku) { create(:sku) }

  describe '#item_count' do
    it 'カート内商品の数量を合計する' do
      create(:cart_item, cart:, sku:, quantity: 2)

      expect(cart.item_count).to eq(2)
    end
  end

  describe '#subtotal' do
    it 'カート内商品の小計を計算する' do
      product = create(:product, price: 5_000)
      sku = create(:sku, product:)

      create(:cart_item, cart:, sku:, quantity: 2)

      expect(cart.subtotal).to eq(10_000)
    end
  end

  describe '#shipping_fee' do
    it '10000円以上なら送料無料' do
      product = create(:product, price: 10_000)
      sku = create(:sku, product:)

      create(:cart_item, cart:, sku:, quantity: 1)

      expect(cart.shipping_fee).to eq(0)
    end

    it '10000円未満なら送料800円' do
      product = create(:product, price: 9_999)
      sku = create(:sku, product:)

      create(:cart_item, cart:, sku:, quantity: 1)

      expect(cart.shipping_fee).to eq(800)
    end
  end

  describe '#total' do
    it '小計と送料の合計を返す' do
      product = create(:product, price: 5_000)
      sku = create(:sku, product:)

      create(:cart_item, cart:, sku:, quantity: 1)

      expect(cart.total).to eq(5_800)
    end
  end
  describe '#remove_item' do
    it '商品をカートから削除する' do
      sku = create(:sku)
      cart_item = create(:cart_item, cart:, sku:, quantity: 1)

      cart.remove_item(sku)

      expect(cart.cart_items).not_to include(cart_item)
    end
  end
end
