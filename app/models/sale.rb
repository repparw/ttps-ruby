class Sale < ApplicationRecord
  belongs_to :user
  belongs_to :customer
  has_many :sale_items
  has_many :products, through: :sale_items

  # Scopes for active/cancelled sales
  scope :active, -> { where(cancelled_at: nil) }
  scope :cancelled, -> { where.not(cancelled_at: nil) }

  # Add nested attributes support
  accepts_nested_attributes_for :sale_items

  # Validations
  validates :user, presence: true
  validates :customer, presence: true
  validates :sale_items, presence: true
  validate :must_have_at_least_one_item
  validate :check_stock_availability

  # Callbacks
  before_save :calculate_total
  after_create :decrement_stock

  def cancel
    return false if cancelled?

    transaction do
      sale_items.each do |item|
        item.product.increment!(:stock, item.quantity)
      end
      update!(cancelled_at: Time.current)
    end
  end

  def cancelled?
    cancelled_at.present?
  end

  def active?
    !cancelled?
  end

  private

  def must_have_at_least_one_item
    if sale_items.empty?
      errors.add(:base, "Debe tener al menos un artículo")
    end
  end

  def check_stock_availability
    sale_items.each do |item|
      if item.product && item.quantity.to_i > item.product.stock.to_i
        errors.add(:base, "No hay suficiente stock para #{item.product.name} (disponible: #{item.product.stock})")
      end
    end
  end

  def decrement_stock
    sale_items.each do |item|
      item.product.decrement!(:stock, item.quantity)
    end
  end

  def calculate_total
    self.total = sale_items.sum { |item| item.quantity * item.price }
  end
end
