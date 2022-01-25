# Devise patching
class CustomFailure < Devise::FailureApp
  def respond
    http_auth
  end
end
