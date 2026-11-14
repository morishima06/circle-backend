# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:order) do
    create(:order, guest_token: 'test-guest-token')
  end

  describe '#expired?' do
    it '有効期限を過ぎていればtrueを返す' do
      order.update!(expires_at: 30.minutes.ago)

      expect(order.expired?).to be true
    end

    it '有効期限内ならfalseを返す' do
      order.update!(expires_at: 30.minutes.from_now)

      expect(order.expired?).to be false
    end
  end

  describe '#items_count' do
    it '注文商品の数量を合計する' do
      create(
        :order_item,
        order:,
        quantity: 2
      )

      create(
        :order_item,
        order:,
        quantity: 3
      )

      expect(order.items_count).to eq(5)
    end
  end

  describe '#calculated_subtotal' do
    it '注文商品の小計を計算する' do
      create(
        :order_item,
        order:,
        price: 5_000,
        quantity: 2
      )

      expect(order.calculated_subtotal).to eq(10_000)
    end
  end

  describe '#calculated_shipping_fee' do
    it '10000円以上なら送料無料' do
      create(
        :order_item,
        order:,
        price: 10_000,
        quantity: 1
      )

      expect(order.calculated_shipping_fee).to eq(0)
    end

    it '10000円未満なら送料800円' do
      create(
        :order_item,
        order:,
        price: 9_999,
        quantity: 1
      )

      expect(order.calculated_shipping_fee).to eq(800)
    end
  end

  describe '#calculated_total' do
    it '小計と送料の合計を返す' do
      create(
        :order_item,
        order:,
        price: 5_000,
        quantity: 1
      )

      expect(order.calculated_total).to eq(5_800)
    end
  end

  describe '#confirm!' do
    it '注文を確定し、注文番号を生成する' do
      payment = create(:payment, order:)

      order.confirm!(payment:)

      expect(order.status).to eq('confirmed')
      expect(order.current_payment).to eq(payment)
      expect(order.ordered_at).to be_present
      expect(order.number).to match(/\A\d+\z/)
    end
  end

  describe '#generate_complete_token' do
    it '注文作成時にcomplete_tokenを生成する' do
      expect(order.complete_token).to be_present
    end
  end
end
