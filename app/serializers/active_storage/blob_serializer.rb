module ActiveStorage
  # :nodoc:
  class BlobSerializer < ActiveModel::Serializer
    attributes :id, :filename, :content_type, :byte_size, :checksum


    attribute(:signed_url) do
      object.service_url_for_direct_upload
    end
  end
end
