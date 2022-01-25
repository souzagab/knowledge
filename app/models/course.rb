class Course < ApplicationRecord
  has_paper_trail

  validates :title, presence: true
  validates :description, presence: true
end
