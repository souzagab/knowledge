require "devise/jwt/test_helpers"

module RequestHelper
  def auth_headers(role: nil)
    user = FactoryBot.create :user, role
    headers = { "Accept" => "application/json", "Content-Type" => "application/json" }

    Devise::JWT::TestHelpers.auth_headers(headers, user)
  end

  def auth_headers_for(user)
    headers = { "Accept" => "application/json", "Content-Type" => "application/json" }

    Devise::JWT::TestHelpers.auth_headers(headers, user)
  end

  def admin_headers
    auth_headers(role: :admin)
  end

  def response_body
    @response_body = JSON.parse response.body
  end
end

RSpec.configure do |config|
  config.include RequestHelper, type: :request
end
