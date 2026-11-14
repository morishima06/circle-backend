# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :customer, optional: true
  has_many :order_items, dependent: :destroy
  has_many :payments, dependent: :destroy
  belongs_to :current_payment, class_name: 'Payment', optional: true
  has_one :shipment, dependent: :destroy
  before_validation :generate_complete_token, on: :create
  before_validation :set_expires_at, on: :create

  enum status: {
    pending: 'pending',
    confirmed: 'confirmed',
    shipped: 'shipped',
    on_hold: 'on_hold',
    cancelled: 'cancelled'
  }

  scope :awaiting_shipment, lambda {
    joins(:payments)
      .where(status: :confirmed)
      .where(
        '(payments.payment_method = :cod) OR (payments.status = :paid)',
        cod: 'cod',
        paid: 'paid'
      )
  }

  scope :ordered_between, lambda { |range|
    where(ordered_at: range)
  }

  scope :search_keyword, lambda { |keyword|
    where(
      'last_name LIKE :q OR first_name LIKE :q OR email LIKE :q OR number LIKE :q',
      q: "%#{sanitize_sql_like(keyword)}%"
    )
  }

  scope :with_statuses, lambda { |statuses|
    where(status: statuses)
  }

  scope :with_payment_status, lambda { |status|
    joins(:current_payment)
      .where(payments: { status: })
  }

  scope :recent, lambda {
    order(ordered_at: :desc)
  }

  def expired?
    expires_at.present? && expires_at < Time.current
  end

  def items_count
    order_items.sum(:quantity)
  end

  def calculated_subtotal
    order_items.sum { |item| item.price * item.quantity }
  end

  def calculated_shipping_fee
    calculated_subtotal >= Pricing::FREE_SHIPPING_THRESHOLD ? 0 : Pricing::SHIPPING_FEE
  end

  def calculated_total
    calculated_subtotal + calculated_shipping_fee
  end

  def confirm!(payment:)
    update!(
      number: generate_order_number,
      status: :confirmed,
      current_payment: payment,
      ordered_at: Time.current,
      shipping_fee: calculated_shipping_fee,
      total: calculated_total
    )
  end

  def generate_complete_token
    return if complete_token.present?

    loop do
      token = SecureRandom.urlsafe_base64

      unless Order.exists?(complete_token: token)
        self.complete_token = token
        break
      end
    end
  end

  def generate_order_number
    return number if number.present?

    sequence = ApplicationRecord.connection.select_value(
      "SELECT nextval('order_number_seq')"
    )

    sequence.to_s
  end

  def set_expires_at
    self.expires_at ||= 30.minutes.from_now
  end
end
