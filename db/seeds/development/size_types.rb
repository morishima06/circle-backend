# frozen_string_literal: true

size_types = [
  { key: 'shoe_jp', name: '靴サイズ（cm）' },
  { key: 'apparel', name: 'アパレルサイズ' },
  { key: 'free', name: 'フリーサイズ' }
]

size_types.each do |attrs|
  SizeType.find_or_create_by!(key: attrs[:key]) do |st|
    st.name = attrs[:name]
  end
end
