RSpec.describe "blobs#show", type: :request do

  let(:file) { file_fixture ["images/image.png", "images/image.jpg", "videos/sample.mp4"].sample }

  # TODO: Helper for generating blobs
  let!(:blob) do
    path = file
    io = File.open path, "rb"
    content_type = Marcel::MimeType.for path

    ActiveStorage::Blob.create_and_upload!(io:, content_type:, filename: path.basename)
  end

  def url(id: blob.id)
    "/blobs/#{id}"
  end

  context "requirements" do
    it "requires authentication" do
      get url

      expect(response).to be_unauthorized
    end

    it "requires blobs to exist" do
      get url(id: 0), headers: auth_headers

      expect(response).to be_not_found
    end
  end

  context "when blob exists" do
    xit "redirects to preview url" do
      # TODO: Understand what is occuring to ActiveStorage::Current.host
      # https://github.com/rails/rails/issues/40855

      get url, headers: auth_headers

      expect(response).to redirect_to "https://localhost:3000/blobs"
    end
  end
end
