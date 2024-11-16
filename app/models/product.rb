class Product < ApplicationRecord
  has_many_attached :images
  belongs_to :category
  has_many :sale_items
  has_many :sales, through: :sale_items

  # Validations
  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :stock, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :images, presence: true, content_type: [ "image/png", "image/jpg", "image/jpeg" ], on: :create
  validates :category, presence: true
  validates :entry_at, presence: true

  # Optional fields
  validates :size, allow_blank: true, length: { maximum: 50 }
  validates :color, allow_blank: true, length: { maximum: 30 }

  # Scopes
  scope :active, -> { where(deleted_at: nil) }
  scope :available, -> { active.where("stock > 0") }

  private

  public

  def soft_delete
    update(deleted_at: Time.current, stock: 0)
  end

  def available?
    self.class.available.exists?(id: id)
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[name description]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "name", "description" ]
  end
end
