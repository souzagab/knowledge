module Courses
  # Contoller for managing enrollments of a course
  class EnrollmentsController < ApplicationController
    prepend_before_action :authenticate_user!
    load_and_authorize_resource
    before_action :find_course

    # GET /courses/:course_id/enrollments
    def index
      enrollments = @course.enrollments

      render json: enrollments
    end

    # POST /courses/:course_id/enrollments
    def create
      enrollment = @course.enrollments.new enrollment_params

      if enrollment.save
        render json: enrollment, status: :created
      else
        render json: enrollment.errors, status: :unprocessable_entity
      end
    end

    # DELETE /courses/:course_id/enrollments/:id
    def destroy
      enrollment = @course.enrollments.find params[:id]

      if enrollment.destroy
        head :no_content
      else
        render json: enrollment.errors, status: :unprocessable_entity
      end
    end

    private

    def find_course
      @course = Course.find params[:course_id]
    end

    def enrollment_params
      params.require(:enrollment).permit :user_id
    end
  end
end
