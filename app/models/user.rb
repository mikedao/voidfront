class User < ApplicationRecord
  has_secure_password
  has_one :empire, dependent: :destroy
  
  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
end