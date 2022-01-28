# Controller for direct uploads on amazon via active-storage
class UploadsController < ApplicationController
  prepend_before_action :authenticate_user!

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

  private

  def file_params
    params.require(:file).permit(:filename, :byte_size, :checksum, :content_type, metadata: {})
  end

end
