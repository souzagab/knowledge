# Represents a content of a course (eg: video)
class Content < ApplicationRecord
  has_paper_trail

  belongs_to :course

  has_one_attached :file

  validates :name, presence: true
end
