class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable

  enum role: {
    admin: "admin",
    user: "user"
  }

  validates :email, presence: true,
    uniqueness: { case_sensitive: false },
    format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :name, presence: true
end
