class Product < ApplicationRecord
  has_many_attached :images
  belongs_to :category
  has_many :sale_items
  has_many :sales, through: :sale_items

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true, numericality: { greater_than: 0 }
  validates :stock, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :images, presence: true, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'] }
  validates :category, presence: true

  scope :available, -> { where(deleted_at: nil) }

  def soft_delete
    update(deleted_at: Time.current, stock: 0)
  end
end
