RSpec.describe "courses#create", type: :request do
  let(:url) { "/courses" }
  let(:course_attributes) { attributes_for :course }
  let(:params) { { course: course_attributes }.to_json }
  let!(:headers) { admin_headers }

  context "requirements" do

    it "requires authentication" do
      post url, params: params

      expect(response).to have_http_status :unauthorized
    end

    context "authorization" do
      it "requires course to be an admin" do
        post url, params: params, headers: auth_headers

        expect(response).to have_http_status :forbidden
      end
    end
  end

  context "when all params sent are valid" do
    # TODO: Helper for generating blobs
    let!(:thumbnail_blob) do
      path = file_fixture "images/image.jpg"
      io = File.open path, "rb"
      content_type = Marcel::MimeType.for path

      ActiveStorage::Blob.create_and_upload!(io:, content_type:, filename: path.basename)
    end

    let!(:course_attributes) { attributes_for :course, thumbnail: thumbnail_blob.signed_id }

    it "creates a new course, with thumbnail attached" do
      expect do
        post url, params: params, headers: admin_headers
      end.to change { Course.count }.by(1)
         .and change { ActiveStorage::Attachment.count }

      expect(response).to have_http_status :created
    end

    with_versioning do
      it "audits who created the new course" do
        # TODO: Fix the request-helper that creates a new user every time is initialized
        expect { post url, params: params, headers: admin_headers }.to change { PaperTrail::Version.count } # .by(1)
      end
    end
  end

  context "when one or more parameters sent are invalid" do
    let!(:course_attributes) { attributes_for :course, :invalid }

    it "does not create a new course, and returns errors" do
      expect { post url, params: params, headers: admin_headers }.not_to change { Course.count }

      expect(response).to have_http_status :unprocessable_entity

      expect(response_body).to have_key "title"
    end
  end
end
