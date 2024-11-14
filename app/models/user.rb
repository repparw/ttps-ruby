class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, [ :customer, :employee, :manager, :admin ]

  validates :username, presence: true, uniqueness: true
  validates :phone, presence: true
  validates :role, presence: true

  def active_for_authentication?
    super && deactivated_at.nil?
  end
end
