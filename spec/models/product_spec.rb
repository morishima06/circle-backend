# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  describe '#on_sale?' do
    it 'セール期間中ならtrueを返す' do
      product = create(
        :product,
        price: 10_000,
        sale_price: 8_000,
        sale_start_at: 1.day.ago,
        sale_end_at: 1.day.from_now
      )

      expect(product.on_sale?).to be true
    end

    it 'セール期間外ならfalseを返す' do
      product = create(
        :product,
        price: 10_000,
        sale_price: 8_000,
        sale_start_at: 2.days.ago,
        sale_end_at: 1.day.ago
      )

      expect(product.on_sale?).to be false
    end

    it 'セール価格がなければfalseを返す' do
      product = create(
        :product,
        price: 10_000,
        sale_price: nil,
        sale_start_at: 1.day.ago,
        sale_end_at: 1.day.from_now
      )

      expect(product.on_sale?).to be false
    end
  end

  describe '#current_price' do
    it 'セール中ならセール価格を返す' do
      product = create(
        :product,
        price: 10_000,
        sale_price: 8_000,
        sale_start_at: 1.day.ago,
        sale_end_at: 1.day.from_now
      )

      expect(product.current_price).to eq(8_000)
    end

    it 'セール期間外なら通常価格を返す' do
      product = create(
        :product,
        price: 10_000,
        sale_price: 8_000,
        sale_start_at: 2.days.ago,
        sale_end_at: 1.day.ago
      )

      expect(product.current_price).to eq(10_000)
    end
  end

  describe '#original_price' do
    it '通常価格を返す' do
      product = create(:product, price: 10_000)

      expect(product.original_price).to eq(10_000)
    end
  end

  describe '#discount_percentage' do
    it '割引率を計算する' do
      product = create(
        :product,
        price: 10_000,
        sale_price: 8_000
      )

      expect(product.discount_percentage).to eq(20)
    end

    it 'セール価格が通常価格以上ならnilを返す' do
      product = create(
        :product,
        price: 10_000,
        sale_price: 10_000
      )

      expect(product.discount_percentage).to be_nil
    end

    it 'セール価格がなければnilを返す' do
      product = create(
        :product,
        price: 10_000,
        sale_price: nil
      )

      expect(product.discount_percentage).to be_nil
    end
  end
end
