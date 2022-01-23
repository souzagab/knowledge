class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :validatable,
    :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  enum role: {
    admin: "admin",
    user: "user"
  }

  validates :email, presence: true,
    uniqueness: { case_sensitive: false },
    format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :name, presence: true
end
