class Enrollment < ApplicationRecord
  has_paper_trail

  belongs_to :course
  belongs_to :user
end
