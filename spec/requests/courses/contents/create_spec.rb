RSpec.describe "courses/contents#create", type: :request do
  let!(:course) { create :course }

  def url(course_id: course.id)
    "/courses/#{course_id}/contents"
  end

  let!(:headers) { admin_headers }
  let!(:params) { { content: attributes_for(:content) }.to_json }

  context "requirements" do
    it "requires authentication" do
      post url, params: params

      expect(response).to have_http_status :unauthorized
    end

    context "authorization" do
      it "only admins can create contents" do
        post url, params: params, headers: auth_headers

        expect(response).to have_http_status :forbidden
      end
    end

    it "requires parent resource (course) to exist" do
      post url(course_id: 0), params: params, headers: admin_headers

      expect(response).to have_http_status :not_found
    end
  end

  context "when all the required params are sent" do
    let!(:blob) { blob_for "videos/sample.mp4" }
    let!(:params) { { content: attributes_for(:content, file: blob.signed_id) }.to_json }

    it "creates a new content for the course" do
      expect do
        post url, params: params, headers: admin_headers
        course.reload
      end.to change { Content.count }.by(1)
        .and change { ActiveStorage::Attachment.count }

      expect(response).to have_http_status :created
    end

    with_versioning do
      it "audits who created the new content" do
        # TODO: Fix the request-helper that creates a new user every time is initialized
        expect { post url, params: params, headers: admin_headers }.to change { PaperTrail::Version.count } # .by(2)
      end
    end
  end

  context "when the required file is not sent" do
    let!(:params) { { content: attributes_for(:content) }.to_json }

    it "does not create a new content, and returns errors on file" do
      expect { post url, params: params, headers: admin_headers }.not_to change { Content.count }

      expect(response).to have_http_status :unprocessable_entity

      expect(response_body["file"]).to match ["can't be blank"]
    end
  end
end
