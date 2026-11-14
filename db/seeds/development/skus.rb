# frozen_string_literal: true
# product = Product.find_by!(style_code: "COHBU-M26388-TZC")

# shoe_type = product.category.size_type

# shoes_sizes = shoe_type.sizes.where(label: ["26.0", "26.5", "27.0"])

# shoes_sizes.each do |size|
#   Sku.find_or_create_by!(
#     product: product,
#     size: size
#   ) do |sku|
#     sku.stock = 10
#   end
# end

# product = Product.find_by!(style_code: "835561-2ABZI-1000")

# size = product.category.size_type.sizes.find_by!(label: "FREE")

# Sku.find_or_create_by!(
#   product: product,
#   size: size
# ) do |sku|
#   sku.stock = 30
# end

# product = Product.find_by!(style_code: "19CMOW702A-110416A-815")

# sizes = product.category.size_type.sizes.where(label: %w[S M L])

# sizes.each do |size|
#   Sku.find_or_create_by!(
#     product: product,
#     size: size
#   ) do |sku|
#     sku.stock = 15
#   end
# end
