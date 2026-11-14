# frozen_string_literal: true

class CreateOrderNumberSequence < ActiveRecord::Migration[6.1]
  def up
    execute <<~SQL.squish
      CREATE SEQUENCE order_number_seq
      START WITH 10000
      INCREMENT BY 1
    SQL
  end

  def down
    execute 'DROP SEQUENCE IF EXISTS order_number_seq'
  end
end
