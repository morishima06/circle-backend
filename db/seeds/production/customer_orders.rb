# frozen_string_literal: true

require 'faker'

customers = Customer.all

skus = Sku.includes(
  :size,
  product: %i[color designer]
).to_a

raise 'Customerが存在しません' if customers.empty?
raise 'Skuが存在しません' if skus.empty?

address_line2_options = [
  nil,
  "○○マンション#{rand(101..1205)}",
  "△△ハイツ#{rand(101..505)}",
  "□□ビル#{rand(2..10)}F",
  "部屋#{rand(101..1505)}"
]

ORDER_PATTERNS = [
  {
    status: 'confirmed',
    payment_status: 'pending',
    shipment_status: 'preparing'
  },
  {
    status: 'confirmed',
    payment_status: 'paid',
    shipment_status: 'preparing'
  },
  {
    status: 'shipped',
    payment_status: 'paid',
    shipment_status: 'shipped'
  },
  {
    status: 'cancelled',
    payment_status: 'refunded',
    shipment_status: 'shipped'
  }
].freeze

50.times do
  customer = customers.sample
  pattern = ORDER_PATTERNS.sample

  order = Order.create!(
    customer:,
    customer_type: 'member',

    last_name: customer.last_name,
    first_name: customer.first_name,
    email: customer.email,
    phone_number: customer.phone_number,

    postal_code: Faker::Address.zip_code,
    prefecture: Faker::Address.state,
    city: Faker::Address.city,
    address_line1: "#{rand(1..5)}丁目#{rand(1..30)}-#{rand(1..30)}",
    address_line2: address_line2_options.sample,

    number: ApplicationRecord.connection.select_value(
      "SELECT nextval('order_number_seq')"
    ).to_s,
    status: pattern[:status],

    shipping_fee: 800,
    total: 0,
    ordered_at: Faker::Time.backward(days: 90)
  )

  subtotal = 0

  rand(1..2).times do
    sku = skus.sample
    quantity = rand(1..2)
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
    status: pattern[:payment_status],
    stripe_payment_intent_id: "pi_#{SecureRandom.hex(12)}"
  )

  order.update!(current_payment_id: payment.id)

  next unless pattern[:shipment_status]

  Shipment.create!(
    order:,
    status: pattern[:shipment_status]
  )
end
