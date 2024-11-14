class Customer < ApplicationRecord
  has_many :sales

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :phone, presence: true
end
