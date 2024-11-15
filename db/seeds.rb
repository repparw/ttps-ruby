require 'open-uri'

User.find_or_create_by!(email: 'admin@avivas.com') do |user|
  user.username = 'admin'
  user.password = 'admin123'
  user.phone = '1234567890'
  user.role = :admin
  user.joined_at = Time.current
end
puts 'Admin user created or already exists.'

User.find_or_create_by!(email: 'manager@avivas.com') do |user|
  user.username = 'manager'
  user.password = 'manager123'
  user.phone = '1122334455'
  user.role = :manager
  user.joined_at = Time.current
end
puts 'Manager user created or already exists.'

User.find_or_create_by!(email: 'employee@avivas.com') do |user|
  user.username = 'employee'
  user.password = 'employee123'
  user.phone = '0987654321'
  user.role = :employee
  user.joined_at = Time.current
end
puts 'Employee user created or already exists.'

categories = %w[Running Training Basketball Soccer Tennis].map do |name|
  Category.find_or_create_by!(name: name)
end

# Create sample customers (with duplicate checking)
10.times do
  Customer.create!(
    name: Faker::Name.unique.name,
    email: Faker::Internet.unique.email,
    phone: Faker::PhoneNumber.phone_number
  )
rescue Faker::UniqueGenerator::RetryLimitExceeded
  Faker::UniqueGenerator.clear
  retry
end

# Create sample products
categories.each do |category|
  5.times do |i|
    product_name = "#{category.name} Product #{i + 1}"

    # Skip if product already exists
    next if Product.exists?(name: product_name, category: category)

    product = Product.new(
      name: product_name,
      description: Faker::Lorem.paragraph,
      price: Faker::Commerce.price(range: 20..200.0),
      stock: Faker::Number.between(from: 10, to: 100),
      category: category,
      size: %w[S M L XL].sample,
      color: Faker::Color.color_name
    )

    # Attempt to attach image with retry logic
    max_retries = 3
    retry_count = 0

    begin
      file = URI.open('https://picsum.photos/800/600')
      product.images.attach(
        io: file,
        filename: "#{product_name.parameterize}.jpg",
        content_type: 'image/jpeg'
      )
    rescue OpenURI::HTTPError => e
      retry_count += 1
      if retry_count < max_retries
        puts "Error downloading image (attempt #{retry_count}/#{max_retries}): #{e.message}"
        sleep(1) # Add a small delay before retrying
        retry
      else
        puts "Failed to download image after #{max_retries} attempts for product: #{product_name}"
      end
    end

    begin
      product.save!
      puts "Created product: #{product_name}"
    rescue ActiveRecord::RecordInvalid => e
      puts "Failed to create product #{product_name}: #{e.message}"
    end
  end
end

puts 'Seed completed successfully!'
