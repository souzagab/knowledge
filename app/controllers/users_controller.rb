# User's controller
class UsersController < ApplicationController
  prepend_before_action :authenticate_user!
  load_and_authorize_resource

  # GET /users
  def index
    users = User.where.not(id: current_user.id)

    render json: users
  end
end
