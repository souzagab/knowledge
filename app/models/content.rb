# Represents a content of a course (eg: video)
class Content < ApplicationRecord
  has_paper_trail

  belongs_to :course

  has_one_attached :file

  delegate :blob_id, to: :file

  validates :name, presence: true
  validates :file, presence: true

  validates :file, attached: true
end
