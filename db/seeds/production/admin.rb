# frozen_string_literal: true

Admin.find_or_create_by!(email: '245224aa@gmail.com') do |admin|
  admin.password = 'password'
  admin.password_confirmation = 'password'
end
