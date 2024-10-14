class User < ApplicationRecord
  has_many :projects, dependent: :destroy
  has_many :tasks, dependent: :destroy

  validates :email, presence: true
  validates :username, presence: true
  validates :nickname, presence: true
end
