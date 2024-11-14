class Product < ApplicationRecord
  has_many_attached :images
  belongs_to :category
  has_many :sale_items
  has_many :sales, through: :sale_items

  # Validations
  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true, numericality: { greater_than: 0 }
  validates :stock, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :images, presence: true, content_type: [ "image/png", "image/jpg", "image/jpeg" ]
  validates :category, presence: true

  # Scopes
  scope :active, -> { where(deleted_at: nil) }
  scope :available, -> { active.where("stock > 0") }

  def soft_delete
    update(deleted_at: Time.current, stock: 0)
  end

  def available?
    self.class.available.exists?(id: id)
  end
end
