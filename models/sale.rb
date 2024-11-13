class Sale < ApplicationRecord
  belongs_to :user
  belongs_to :customer
  has_many :sale_items
  has_many :products, through: :sale_items

  validates :user, presence: true
  validates :customer, presence: true
  validates :sale_items, presence: true

  before_save :calculate_total

  def cancel
    transaction do
      sale_items.each do |item|
        item.product.increment!(:stock, item.quantity)
      end
      update!(cancelled_at: Time.current)
    end
  end

  private

  def calculate_total
    self.total = sale_items.sum { |item| item.quantity * item.price }
  end
end
