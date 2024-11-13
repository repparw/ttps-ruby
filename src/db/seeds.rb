# Create admin user
User.create!(
  username: 'admin',
  email: 'admin@avivas.com',
  password: 'password123',
  phone: '1234567890',
  role: :admin,
  joined_at: Time.current
)

# Create categories
categories = ['Running', 'Training', 'Basketball', 'Soccer', 'Tennis'].map do |name|
  Category.create!(name: name)
end

# Create sample products
categories.each do |category|
  5.times do
    Product.create!(
      name: Faker::Commerce.product_name,
      description: Faker::Lorem.paragraph,
      unit_price: Faker::Commerce.price(range: 20..200.0),
      stock: Faker::Number.between(from: 10, to: 100),
      category: category,
      size: ['S', 'M', 'L', 'XL'].sample,
      color: Faker::Color.color_name
    )
  end
end

# Create sample customers
10.times do
  Customer.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    phone: Faker::PhoneNumber.phone_number
  )
end
