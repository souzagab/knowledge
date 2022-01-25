# User's controller
class UsersController < ApplicationController
  prepend_before_action :authenticate_user!
  load_and_authorize_resource

  # GET /users
  def index
    users = User.where.not(id: current_user.id)

    render json: users
  end

  # GET /users/:id
  def show
    render json: @user
  end

  # POST /users
  def create
    user = User.new(user_params)

    if user.save
      render json: user, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/:id
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/:id
  def destroy
    @user.destroy
  end

  private

  def user_params
    params.require(:user).permit %i[name email password role]
  end
end
