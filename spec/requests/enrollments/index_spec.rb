RSpec.describe "courses/enrollments#index", type: :request do
  let!(:course) { create :course }

  def url(course_id: course.id)
    "/courses/#{course_id}/enrollments"
  end

  context "requirements" do
    it "requires authentication" do
      get url

      expect(response).to have_http_status :unauthorized
    end

    context "authorization" do
      it "requires user to be an admin" do
        get url, headers: admin_headers

        expect(response).to have_http_status :ok
      end
    end

    it "requires parent resource (course) to exist" do
      get url(course_id: 0), headers: admin_headers

      expect(response).to have_http_status :not_found
    end
  end

  context "when there are no enrollments for the course" do
    it "responds with :ok status and an empty list" do
      get url, headers: admin_headers

      expect(response).to have_http_status :ok

      expect(response_body).to eq []
    end
  end

  context "when there are enrollments for the course" do
    let!(:enrollments) { create_list :enrollment, rand(1...3), course: course }

    it "responds with :ok status with courses's list" do
      get url, headers: admin_headers

      expect(response).to have_http_status :ok

      expect(response_body.size).to eq enrollments.size
    end
  end
end
