# frozen_string_literal: true

class AddTrigramIndexToProductsAndDesigners < ActiveRecord::Migration[6.1]
  def change
    add_index :products, :search_name, using: :gin, opclass: :gin_trgm_ops, name: 'index_products_on_search_name_trgm'
  end
end
