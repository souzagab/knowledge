RSpec.describe "courses#destroy", type: :request do
  let!(:course) { create :course }
  let!(:params) { { course: {} }.to_json }

  def url(id: course.id)
    "/courses/#{id}"
  end

  context "requirements" do
    it "requires authentication" do
      put url

      expect(response).to have_http_status :unauthorized
    end

    context "authorization" do
      it "requires course to be an admin" do
        put url, params: params, headers: auth_headers

        expect(response).to have_http_status :forbidden
      end
    end

    it "requires course to exist" do
      put url(id: 0), params: params, headers: admin_headers

      expect(response).to have_http_status :not_found
    end
  end

  context "when the course exists and valid params are used" do
    let!(:params) { { course: { title: "Test" } }.to_json }

    it "updates the existing resource" do
      expect do
        put url, params: params, headers: admin_headers
        course.reload
      end.to change { course.title }

      expect(response).to have_http_status :ok
    end
  end

  context "when the course exists but invalid params are used" do
    let!(:params) { { course: { title: nil } }.to_json }

    it "updates the existing resource" do
      expect do
        put url, params: params, headers: admin_headers
        course.reload
      end.not_to change { course.title }

      expect(response).to have_http_status :unprocessable_entity
      expect(response_body).to have_key "title"
    end
  end
end
