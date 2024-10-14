class Task < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates :title, presence: true
  validates :status, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :project_id, presence: true
  validates :user_id, presence: true
end
