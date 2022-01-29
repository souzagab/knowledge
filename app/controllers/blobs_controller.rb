# Controller for direct uploads on amazon via active-storage
class BlobsController < ApplicationController
  prepend_before_action :authenticate_user!

  # POST /blobs
  def create
    # TODO: Blobs are only attached to courses, if we expand this structure
    #        we need to authorize the specific resources
    authorize! Course, :manage

    # TODO: Isolate logic from controller, checking for failures
    # key: nil, filename:, byte_size:, checksum:, content_type: nil, metadata: nil, service_name: nil, record: nil
    blob = ActiveStorage::Blob.create_before_direct_upload! filename: blob_params["filename"],
                                                            byte_size: blob_params["byte_size"],
                                                            checksum: blob_params["checksum"],
                                                            content_type: blob_params["content_type"],
                                                            metadata: blob_params["metadata"]

    render json: blob, status: :created
  end

  # GET /blobs/:id
  def show
    blob = ActiveStorage::Blob.find params[:id]

    expires_in ActiveStorage.service_urls_expire_in

    blob_url = Rails.application.routes.url_helpers.rails_blob_path(blob, only_path: true)

    redirect_to blob_url
  end

  private

  def blob_params
    params.require(:blob).permit(:filename, :byte_size, :checksum, :content_type, metadata: {})
  end

end
