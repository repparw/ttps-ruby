class SaleItem < ApplicationRecord
  belongs_to :sale
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validate :stock_availability

  private

  def stock_availability
    return unless product && quantity

    if quantity > product.stock
      errors.add(:quantity, "exceeds available stock")
    end
  end
end
