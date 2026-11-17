# frozen_string_literal: true

require 'faker'

skus = Sku.includes(
  :size,
  product: %i[color designer]
).to_a

raise 'Skuが存在しません' if skus.empty?

20.times do
  order = Order.create!(
    guest_token: SecureRandom.uuid,
    customer_type: 'guest',

    last_name: Faker::Name.last_name,
    first_name: Faker::Name.first_name,
    email: Faker::Internet.email,
    phone_number: Faker::PhoneNumber.cell_phone,

    postal_code: Faker::Address.zip_code,
    prefecture: Faker::Address.state,
    city: Faker::Address.city,
    address_line1: Faker::Address.street_address,

    number: "G#{SecureRandom.hex(5).upcase}",
    status: %w[pending paid preparing shipped completed].sample,

    shipping_fee: 800,
    total: 0,
    ordered_at: Faker::Time.backward(days: 90)
  )

  subtotal = 0

  rand(1..2).times do
    sku = skus.sample

    quantity = rand(1..3)
    price = sku.product.sale_price.presence || sku.product.price

    OrderItem.create!(
      order:,
      sku_id: sku.id,

      name: sku.product.name,
      color: sku.product.color.name,
      size: sku.size.label,
      designer: sku.product.designer.name,

      price:,
      original_price: sku.product.price,
      quantity:
    )

    subtotal += price * quantity
  end

  order.update!(
    total: subtotal + order.shipping_fee
  )

  payment = Payment.create!(
    order:,
    payment_method: %w[cod card].sample,
    status: %w[pending paid failed cancelled refunded].sample,
    stripe_payment_intent_id: "pi_#{SecureRandom.hex(12)}"
  )

  order.update!(current_payment_id: payment.id)

  Shipment.create!(
    order:,
    status: %w[pending shipped delivered].sample
  )
end
