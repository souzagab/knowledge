module Courses
  # Contents of a course
  class ContentsController < ApplicationController
    prepend_before_action :authenticate_user!
    load_and_authorize_resource

    before_action :find_course
    before_action :find_content, only: %i[show destroy]

    # GET /courses/:course_id/contents
    def index
      contents = Content.accessible_by(current_ability)

      render json: contents
    end

    # POST /courses/:course_id/contents
    def create
      content = @course.contents.build content_params

      if content.save
        render json: content, status: :created
      else
        render json: content.errors, status: :unprocessable_entity
      end
    end

    # GET /courses/:course_id/contents/:id
    def show
      render json: @content
    end

    # DELETE /courses/:course_id/contents/:id
    def destroy
      if @content.destroy
        head :no_content
      else
        render json: content.errors, status: :unprocessable_entity
      end
    end

    private

    def find_course
      @course = Course.find params[:course_id]
    end

    def find_content
      @content = @course.contents.find params[:id]
    end

    def content_params
      params.require(:content).permit %i[name description file]
    end
  end
end
