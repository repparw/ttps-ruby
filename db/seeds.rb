require 'open-uri'

# Create admin user
User.find_or_create_by!(email: 'admin@avivas.com') do |user|
  user.username = 'admin'
  user.password = 'password123'
  user.phone = '1234567890'
  user.role = :admin
  user.joined_at = Time.current
end

# Create categories (only if they don't exist)
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
      unit_price: Faker::Commerce.price(range: 20..200.0),
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
