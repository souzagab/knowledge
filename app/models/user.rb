class User < ApplicationRecord
  has_paper_trail

  devise :database_authenticatable, :registerable, :recoverable, :validatable,
    :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  has_many :enrollments, dependent: :destroy

  enum role: {
    admin: "admin",
    user: "user"
  }

  validates :email, presence: true,
    uniqueness: { case_sensitive: false },
    format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :name, presence: true
end
