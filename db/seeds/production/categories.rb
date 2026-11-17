# frozen_string_literal: true

shoe_type    = SizeType.find_by!(key: 'shoe_jp')
apparel_type = SizeType.find_by!(key: 'apparel')
free_type    = SizeType.find_by!(key: 'free')

# ===== MENS =====
mens = Category.create!(name: 'Mens')

mens_clothing = mens.children.create!(name: 'Clothing')
mens_clothing.children.create!(
  [
    { name: 'Pants',       size_type: apparel_type },
    { name: 'T-Shirts',    size_type: apparel_type },
    { name: 'Shorts',      size_type: apparel_type },
    { name: 'Jackets',     size_type: apparel_type },
    { name: 'Sweatshirts', size_type: apparel_type },
    { name: 'Shirts',      size_type: apparel_type },
    { name: 'Hoodies',     size_type: apparel_type },
    { name: 'Jeans',       size_type: apparel_type }
  ]
)

mens_accessories = mens.children.create!(name: 'Accessories')
mens_accessories.children.create!(
  [
    { name: 'Hats',      size_type: free_type },
    { name: 'Caps',      size_type: free_type },
    { name: 'Socks',     size_type: free_type },
    { name: 'Belts',     size_type: free_type },
    { name: 'Wallets',   size_type: free_type },
    { name: 'Underwear', size_type: free_type }
  ]
)

mens_bags = mens.children.create!(name: 'Bags')
mens_bags.children.create!(
  [
    { name: 'Tote Bags', size_type: free_type },
    { name: 'Backpacks', size_type: free_type }
  ]
)

mens_footwear = mens.children.create!(name: 'Footwear')
mens_footwear.children.create!(
  [
    { name: 'Boots',    size_type: shoe_type },
    { name: 'Sandals',  size_type: shoe_type },
    { name: 'Sneakers', size_type: shoe_type }
  ]
)

# ===== WOMENS =====
Category.create!(name: 'Womens')
