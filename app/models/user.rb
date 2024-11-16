class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, [ :employee, :manager, :admin ]

  validates :username, presence: true, uniqueness: true
  validates :phone, presence: true
  validates :role, presence: true

  def admin?
    role == "admin"
  end

  def manager?
    role == "manager"
  end

  def employee?
    role == "employee"
  end

  def active_for_authentication?
    super && deactivated_at.nil?
  end

  def soft_delete
    self.deactivated_at = Time.current
    self.password = SecureRandom.hex(20)
    self.password_confirmation = self.password
    save!
  end

  def restore
    update(deactivated_at: nil)
  end
end
