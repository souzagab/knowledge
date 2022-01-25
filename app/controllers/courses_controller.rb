# Courses controller
class CoursesController < ApplicationController
  prepend_before_action :authenticate_user!
  load_and_authorize_resource

  # GET /courses
  def index
    courses = Course.all

    render json: courses
  end

  # GET /courses/:id
  def show
    render json: @course
  end

  # POST /courses
  def create
    course = Course.new course_params

    if course.save
      render json: course, status: :created
    else
      render json: course.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /courses/:id
  def update
    if @course.update course_params
      render json: @course
    else
      render json: @course.errors, status: :unprocessable_entity
    end
  end

  # DELETE /courses/:id
  def destroy
    @course.destroy
  end

  private

  def course_params
    params.require(:course).permit %i[title description]
  end

end
