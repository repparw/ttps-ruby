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

puts 'Creating 10 random users...'
10.times do
  begin
    user = User.create!(
      username: Faker::Internet.unique.username,
      email: Faker::Internet.unique.email,
      password: 'password123',
      phone: Faker::PhoneNumber.phone_number,
      role: [ :admin, :manager, :employee ].sample,
      joined_at: Time.current
    )
    puts "Created user: #{user.username} (#{user.email})"
  rescue Faker::UniqueGenerator::RetryLimitExceeded
    Faker::UniqueGenerator.clear
    retry
  end
end
puts '10 random users created.'

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

product_counter = 1

categories.each do |category|
  5.times do
    product_name = "Producto #{product_counter}"
    product_counter += 1

    # Skip if product already exists
    next if Product.exists?(name: product_name, category: category)

    product = Product.new(
      name: product_name,
      description: Faker::Lorem.paragraph,
      price: Faker::Commerce.price(range: 20..200.0),
      stock: Faker::Number.between(from: 10, to: 100),
      category: category,
      size: %w[S M L XL].sample,
      color: Faker::Color.color_name,
      entry_at: Faker::Date.between(from: 1.year.ago, to: Date.current)
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

# Create sample sales
puts 'Creating sample sales...'
users = User.all
customers = Customer.all
products = Product.all

10.times do
  user = users.sample
  customer = customers.sample

  sale_items = []
  3.times do
    product = products.sample
    quantity = Faker::Number.between(from: 1, to: [ product.stock, 5 ].min)
    sale_items << SaleItem.new(product: product, quantity: quantity, price: product.price)
  end

  sale = Sale.new(
    user: user,
    customer: customer,
    sale_date: Time.current,
    sale_items: sale_items
  )

  if sale.save
    puts "Created sale for user: #{user.username}, customer: #{customer.name}"
  else
    puts "Failed to create sale: #{sale.errors.full_messages.join(', ')}"
  end
end
puts 'Sample sales created.'

puts 'Seed completed successfully!'
