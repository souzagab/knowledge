RSpec.describe "blobs#create", type: :request do
  let(:url) { "/blobs" }

  let(:file) { file_fixture ["images/image.png", "images/image.jpg", "videos/sample.mp4"].sample }

  # TODO: Helper for creating upload params for testing (eg: `upload_params_for(file)`)
  let(:params) do
    {
      file: {
        filename:     file.basename,
        content_type: Marcel::MimeType.for(file),
        byte_size:    File.size(file),
        checksum:     Digest::MD5.base64digest(file.read)
      }
    }.to_json
  end

  context "requirements" do
    it "requires authentication" do
      post url, params: params

      expect(response).to be_unauthorized
    end

    xcontext "authorization" do
      it "only admins can create blobs" do
        post url, params: params, headers: auth_headers

        expect(response).to be_forbidden
      end
    end
  end

  context "when all required params are sent" do
    it "creates a new blob, and returns url for direct upload" do
      expect do
        post url, params: params, headers: auth_headers
      end.to change { ActiveStorage::Blob.count }.by(1)

      expect(response).to have_http_status :created

      expect(response_body).to have_key "signed_url"
    end
  end
end
