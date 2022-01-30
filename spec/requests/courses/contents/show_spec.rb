RSpec.describe "courses/contents#show", type: :request do
  let!(:course) { create :course }

  let!(:content) { create :content, course: course }

  def url(course_id: course.id, id: content.id)
    "/courses/#{course_id}/contents/#{id}"
  end

  context "requirements" do
    it "requires authentication" do
      get url

      expect(response).to have_http_status :unauthorized
    end

    context "authorization" do
      it "user can only see contents of enrolled courses" do
        get url, headers: auth_headers

        expect(response).to have_http_status :forbidden
      end
    end

    it "requires course to exist" do
      get url(course_id: 0), headers: admin_headers

      expect(response).to have_http_status :not_found
    end

    it "requires content to exist" do
      get url(id: 0), headers: admin_headers

      expect(response).to have_http_status :not_found
    end
  end

  context "when the course exists" do
    it "responds with the existing resource" do
      get url, headers: admin_headers

      expect(response).to have_http_status :ok

      # TODO: Test serialization
      expect(response_body["id"]).to eq content.id
      expect(response_body["blob_id"]).to eq content.blob_id
    end
  end
end
