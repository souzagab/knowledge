# Controller for direct uploads on amazon via active-storage
class BlobsController < ApplicationController
  prepend_before_action :authenticate_user!

  # POST /blobs
  def create
    # key: nil, filename:, byte_size:, checksum:, content_type: nil, metadata: nil, service_name: nil, record: nil
    blob = ActiveStorage::Blob.create_before_direct_upload! filename: file_params["filename"],
                                                            byte_size: file_params["byte_size"],
                                                            checksum: file_params["checksum"],
                                                            content_type: file_params["content_type"],
                                                            metadata: file_params["metadata"]

    signed_url = blob.service_url_for_direct_upload # expiration_time

    render json: { signed_url: }, status: :created
  end

  # GET /blobs/:id
  def show
    blob = ActiveStorage::Blob.find params[:id]

    expires_in ActiveStorage.service_urls_expire_in
    redirect_to blob.url(disposition: content_disposition)
  end

  private

  def blob_params
    params.require(:file).permit(:filename, :byte_size, :checksum, :content_type, metadata: {})
  end

  def content_disposition
    params.permit(:disposition)
  end
end
