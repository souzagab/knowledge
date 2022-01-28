class Course < ApplicationRecord
  has_paper_trail

  has_many :enrollments, dependent: :restrict_with_error

  has_many :attendees, through: :enrollments, source: :user

  has_many :contents, dependent: :destroy

  has_one_attached :thumbnail

  delegate :blob_id, to: :thumbnail, prefix: true

  validates :title, presence: true
  validates :description, presence: true
end
