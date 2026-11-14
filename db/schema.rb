# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2026_09_07_213744) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.string "last_name"
    t.string "first_name"
    t.string "last_name_kana"
    t.string "first_name_kana"
    t.string "postal_code", null: false
    t.string "prefecture", null: false
    t.string "city", null: false
    t.string "address_line1", null: false
    t.string "address_line2"
    t.string "phone_number", null: false
    t.boolean "is_default", default: false
    t.string "address_type", default: "shipping"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["customer_id"], name: "index_addresses_on_customer_id"
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "cart_items", force: :cascade do |t|
    t.bigint "cart_id", null: false
    t.bigint "sku_id", null: false
    t.integer "price"
    t.integer "quantity", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cart_id", "sku_id"], name: "index_cart_items_on_cart_id_and_sku_id", unique: true
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["sku_id"], name: "index_cart_items_on_sku_id"
  end

  create_table "carts", force: :cascade do |t|
    t.string "guest_token"
    t.bigint "customer_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["customer_id"], name: "index_carts_on_customer_id", unique: true
    t.index ["guest_token"], name: "index_carts_on_guest_token", unique: true
    t.check_constraint "(guest_token IS NOT NULL) OR (customer_id IS NOT NULL)", name: "carts_guest_or_customer_presence"
  end

  create_table "categories", force: :cascade do |t|
    t.bigint "size_type_id"
    t.string "name", null: false
    t.string "slug", null: false
    t.string "ancestry"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["size_type_id"], name: "index_categories_on_size_type_id"
  end

  create_table "colors", force: :cascade do |t|
    t.string "slug", null: false
    t.string "name", null: false
    t.string "group_slug", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_slug"], name: "index_colors_on_group_slug"
    t.index ["slug"], name: "index_colors_on_slug", unique: true
  end

  create_table "customers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: ""
    t.string "last_name"
    t.string "first_name"
    t.string "last_name_kana"
    t.string "first_name_kana"
    t.date "birth_date"
    t.string "gender"
    t.string "phone_number"
    t.string "status", default: "active", null: false
    t.datetime "last_verified_at"
    t.boolean "two_factor_enabled", default: true
    t.string "trusted_device_token_digest"
    t.datetime "trusted_device_token_expires_at"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "guest_token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_customers_on_email", unique: true
    t.index ["guest_token"], name: "index_customers_on_guest_token", unique: true
    t.index ["reset_password_token"], name: "index_customers_on_reset_password_token", unique: true
  end

  create_table "designers", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "favorites", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "product_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["customer_id"], name: "index_favorites_on_customer_id"
    t.index ["product_id"], name: "index_favorites_on_product_id"
  end

  create_table "oauth_identities", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["customer_id", "provider"], name: "index_oauth_identities_on_customer_id_and_provider", unique: true
    t.index ["customer_id"], name: "index_oauth_identities_on_customer_id"
    t.index ["provider", "uid"], name: "index_oauth_identities_on_provider_and_uid", unique: true
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.integer "sku_id"
    t.string "name", null: false
    t.string "color"
    t.string "size"
    t.string "designer"
    t.integer "price", null: false
    t.integer "original_price", null: false
    t.integer "quantity", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "customer_id"
    t.bigint "current_payment_id"
    t.string "customer_type", default: "guest", null: false
    t.integer "selected_address_id"
    t.string "last_name"
    t.string "first_name"
    t.string "email"
    t.string "postal_code"
    t.string "prefecture"
    t.string "city"
    t.string "address_line1"
    t.string "address_line2"
    t.string "phone_number"
    t.string "number"
    t.string "status", default: "pending", null: false
    t.datetime "ordered_at"
    t.integer "shipping_fee"
    t.integer "total"
    t.string "guest_token"
    t.string "complete_token"
    t.string "notes"
    t.datetime "expires_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["complete_token"], name: "index_orders_on_complete_token"
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["expires_at"], name: "index_orders_on_expires_at"
    t.index ["guest_token"], name: "index_orders_on_guest_token"
    t.index ["number"], name: "index_orders_on_number", unique: true, where: "(number IS NOT NULL)"
    t.index ["ordered_at"], name: "index_orders_on_ordered_at"
    t.index ["status"], name: "index_orders_on_status"
    t.check_constraint "((customer_id IS NOT NULL) AND (guest_token IS NULL)) OR ((customer_id IS NULL) AND (guest_token IS NOT NULL))", name: "customer_or_guest_token"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.string "stripe_payment_intent_id"
    t.string "payment_method", null: false
    t.string "status", default: "pending", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_payments_on_order_id"
    t.index ["status"], name: "index_payments_on_status"
    t.index ["stripe_payment_intent_id"], name: "index_payments_on_stripe_payment_intent_id", unique: true
  end

  create_table "products", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "designer_id", null: false
    t.bigint "color_id", null: false
    t.string "name"
    t.string "gender"
    t.string "style_code"
    t.string "style_code_slug"
    t.integer "price", null: false
    t.string "search_name"
    t.integer "sale_price"
    t.datetime "sale_start_at"
    t.datetime "sale_end_at"
    t.datetime "release_at"
    t.integer "view_count", default: 0, null: false
    t.string "status", default: "active"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["color_id"], name: "index_products_on_color_id"
    t.index ["designer_id"], name: "index_products_on_designer_id"
    t.index ["search_name"], name: "index_products_on_search_name"
    t.index ["search_name"], name: "index_products_on_search_name_trgm", opclass: :gin_trgm_ops, using: :gin
  end

  create_table "profiles", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "last_name_kana"
    t.string "first_name_kana"
    t.date "birth_date"
    t.string "gender"
    t.string "phone_number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["customer_id"], name: "index_profiles_on_customer_id"
  end

  create_table "reserved_stocks", force: :cascade do |t|
    t.bigint "sku_id", null: false
    t.bigint "order_item_id", null: false
    t.integer "quantity", null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["expires_at"], name: "index_reserved_stocks_on_expires_at"
    t.index ["order_item_id"], name: "index_reserved_stocks_on_order_item_id"
    t.index ["sku_id", "order_item_id"], name: "index_reserved_stocks_on_sku_id_and_order_item_id", unique: true
    t.index ["sku_id"], name: "index_reserved_stocks_on_sku_id"
  end

  create_table "shipments", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.string "status", default: "preparing", null: false
    t.string "carrier_name"
    t.string "tracking_number"
    t.datetime "shipped_at"
    t.datetime "delivered_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_shipments_on_order_id"
    t.index ["status"], name: "index_shipments_on_status"
    t.index ["tracking_number"], name: "index_shipments_on_tracking_number"
  end

  create_table "size_types", force: :cascade do |t|
    t.string "key", null: false
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sizes", force: :cascade do |t|
    t.bigint "size_type_id", null: false
    t.string "label", null: false
    t.integer "position", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["size_type_id"], name: "index_sizes_on_size_type_id"
  end

  create_table "skus", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "size_id", null: false
    t.integer "stock", default: 0, null: false
    t.string "sku_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id", "size_id"], name: "index_skus_on_product_id_and_size_id", unique: true
    t.index ["product_id"], name: "index_skus_on_product_id"
    t.index ["size_id"], name: "index_skus_on_size_id"
    t.index ["sku_code"], name: "index_skus_on_sku_code", unique: true
    t.check_constraint "stock >= 0", name: "stock_non_negative"
  end

  create_table "specs", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "key"
    t.string "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_specs_on_product_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "addresses", "customers"
  add_foreign_key "cart_items", "carts"
  add_foreign_key "cart_items", "skus"
  add_foreign_key "carts", "customers"
  add_foreign_key "categories", "size_types"
  add_foreign_key "favorites", "customers"
  add_foreign_key "favorites", "products"
  add_foreign_key "oauth_identities", "customers"
  add_foreign_key "order_items", "orders"
  add_foreign_key "orders", "customers"
  add_foreign_key "payments", "orders"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "colors"
  add_foreign_key "products", "designers"
  add_foreign_key "profiles", "customers"
  add_foreign_key "reserved_stocks", "order_items"
  add_foreign_key "reserved_stocks", "skus"
  add_foreign_key "shipments", "orders"
  add_foreign_key "sizes", "size_types"
  add_foreign_key "skus", "products"
  add_foreign_key "skus", "sizes"
  add_foreign_key "specs", "products"
end
