class User < ApplicationRecord
  validates :email, presence: true
  validates :username, presence: true
  validates :nickname, presence: true
end
