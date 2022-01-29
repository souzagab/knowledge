RSpec.describe "courses/enrollments#destroy", type: :request do
  let!(:course) { create :course }
  let!(:enrollment) { create :enrollment, course: course }

  def url(course_id: course.id, id: enrollment.id)
    "/courses/#{course_id}/enrollments/#{id}"
  end

  context "requirements" do
    it "requires authentication" do
      delete url

      expect(response).to have_http_status :unauthorized
    end

    context "authorization" do
      it "only admins can remove enrollments" do
        delete url, headers: auth_headers

        expect(response).to have_http_status :forbidden
      end
    end

    it "requires the parent resource (course) to exist" do
      delete url(course_id: 0), headers: admin_headers

      expect(response).to have_http_status :not_found
    end

    it "requires the enrollment to exist" do
      delete url(id: 0), headers: admin_headers

      expect(response).to have_http_status :not_found
    end
  end

  context "when the enrollment exists" do
    it "deletes de enrollment and responds with :no_content" do
      expect { delete url, headers: admin_headers }.to change { Enrollment.count }.by(-1)

      expect(response).to have_http_status :no_content
    end
  end
end
