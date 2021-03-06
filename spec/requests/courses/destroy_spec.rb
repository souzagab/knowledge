RSpec.describe "courses#destroy", type: :request do
  let!(:course) { create :course }

  def url(id: course.id)
    "/courses/#{id}"
  end

  context "requirements" do
    it "requires authentication" do
      delete url

      expect(response).to have_http_status :unauthorized
    end

    context "authorization" do
      it "only admins can remove courses" do
        delete url, headers: auth_headers

        expect(response).to have_http_status :forbidden
      end
    end

    it "requires course to exist" do
      delete url(id: 0), headers: admin_headers

      expect(response).to have_http_status :not_found
    end
  end

  context "when the course exists" do

    it "delete the course record" do
      expect { delete url, headers: admin_headers }.to change { Course.count }.by(-1)

      expect(response).to have_http_status :no_content
    end
  end

  context "when the course have active enrrollments" do
    before { create :enrollment, course: course }

    it "fails to destroy course, and returns errors" do
      expect { delete url, headers: admin_headers }.not_to change { Course.count }

      expect(response).to have_http_status :unprocessable_entity
    end
  end
end
