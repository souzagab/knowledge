class Course < ApplicationRecord
  has_paper_trail

  validates :title, presence: true
  validates :description, presence: true

  has_many :enrollments
  has_many :attendees, through: :enrollments, source: :user
end
