module Courses
  # Contents of a course
  class ContentsController < ApplicationController
    prepend_before_action :authenticate_user!
    load_and_authorize_resource
    before_action :find_course

    def create
      content = @course.contents.build content_params

      if content.save
        render json: content, status: :created
      else
        render json: content.errors, status: :unprocessable_entity
      end
    end

    private

    def find_course
      @course = Course.find params[:course_id]
    end

    def content_params
      params.require(:content).permit %i[name description file]
    end
  end
end
