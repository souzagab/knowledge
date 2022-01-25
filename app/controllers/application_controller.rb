# ApplicationController
class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  rescue_from CanCan::AccessDenied, with: :forbidden!

  def forbidden!(err = nil, message: "Forbidden")
    render json: { error: err.try(:message) || message }, status: :forbidden
  end
end
