module UploadHelpers
  # Methods to assist in creating files for upload
  module Methods
    # Generates a ActiveStorage::Blob for a file in '/spec/fixtures/files', and returns the ActiveStorage::Blob
    # eg: `blob_for "images/sample.jpg"`
    def blob_for(file_name)
      fixture = file_fixture file_name

      io = File.open(fixture, "rb")
      content_type = Marcel::MimeType.for fixture
      filename = fixture.basename

      ActiveStorage::Blob.create_and_upload! io:, filename:, content_type:
    end
  end
end

RSpec.configure do |config|
  config.include UploadHelpers::Methods
end
