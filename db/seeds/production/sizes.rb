# frozen_string_literal: true

# == Apparel Sizes (S/M/L) ==
apparel_type = SizeType.find_by!(key: 'apparel')

[
  { label: 'S', position: 10 },
  { label: 'M', position: 20 },
  { label: 'L', position: 30 },
  { label: 'XL', position: 40 } # 必要なら
].each do |attrs|
  Size.find_or_create_by!(
    size_type: apparel_type,
    label: attrs[:label]
  ) do |s|
    s.position = attrs[:position]
  end
end

# == Shoe Sizes ==
shoe_type = SizeType.find_by!(key: 'shoe_jp')

[
  { label: '25.0', position: 250 },
  { label: '25.5', position: 255 },
  { label: '26.0', position: 260 },
  { label: '26.5', position: 265 },
  { label: '27.0', position: 270 },
  { label: '27.5', position: 275 },
  { label: '28.0', position: 280 },
  { label: '28.5', position: 285 }
].each do |attrs|
  Size.find_or_create_by!(
    size_type: shoe_type,
    label: attrs[:label]
  ) do |s|
    s.position = attrs[:position]
  end
end

# == Free Size ==
free_type = SizeType.find_by!(key: 'free')

Size.find_or_create_by!(
  size_type: free_type,
  label: 'ONE SIZE'
) do |s|
  s.position = 0
end
