# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create default package
Package.find_or_create_by!(name: 'Free Package') do |package|
  package.free_listings_count = 5
  package.max_photos_per_listing = 5
  package.is_default = true
  package.status = :active
end

# Create other packages
Package.find_or_create_by!(name: 'Basic Package') do |package|
  package.free_listings_count = 10
  package.max_photos_per_listing = 8
  package.is_default = false
  package.status = :active
end

Package.find_or_create_by!(name: 'Premium Package') do |package|
  package.free_listings_count = 20
  package.max_photos_per_listing = 10
  package.is_default = false
  package.status = :active
end
