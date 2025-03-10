# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# db/seeds.rb
admin = User.find_or_create_by(email: 'newadmin2@gmail.com') do |user|
  user.first_name = 'newadmin'
  user.last_name = '2'
  user.phone_number = '8601082965'
  user.password = 'newadmin#1234'
  user.password_confirmation = 'newadmin#1234'
end

admin.add_role(:admin) # Assuming you are using Rolify
# admin.save!
