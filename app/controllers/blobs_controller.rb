# Controller for direct uploads on amazon via active-storage
class BlobsController < ApplicationController

  prepend_before_action :authenticate_user!

  # POST /blobs
  def create
    # TODO: Blobs are only attached to courses, if we expand this structure
    #        we need to authorize the specific resources
    authorize! Course, :manage

    blob = ActiveStorage::Blob.create_before_direct_upload! **blob_params.to_h.symbolize_keys

    render json: blob, status: :created
  end

  # GET /blobs/:id
  def show
    blob = ActiveStorage::Blob.find params[:id]

    expires_in ActiveStorage.service_urls_expire_in

    redirect_to blob.url, allow_other_host: true
  end

  private

  def blob_params
    params.require(:blob).permit(:filename, :byte_size, :checksum, :content_type, metadata: {})
  end

end
