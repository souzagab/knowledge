RSpec.describe "courses/enrollments#create", type: :request do
  let!(:course) { create :course }

  def url(course_id: course.id)
    "/courses/#{course_id}/enrollments"
  end

  let(:user) { create :user }
  let(:params) { { enrollment: { user_id: user.id } }.to_json }
  let!(:headers) { admin_headers }

  context "requirements" do
    it "requires authentication" do
      post url, params: params

      expect(response).to have_http_status :unauthorized
    end

    context "authorization" do
      it "only admins can create enrollments" do
        post url, params: params, headers: auth_headers

        expect(response).to have_http_status :forbidden
      end
    end

    it "requires parent resource (course) to exist" do
      get url(course_id: 0), headers: admin_headers

      expect(response).to have_http_status :not_found
    end
  end

  context "when the user sent is valid" do
    it "creates a new enrollment for the course" do
      expect do
        post url, params: params, headers: admin_headers
        course.reload
      end.to change { Enrollment.count }.by(1)
        .and change { course.attendees }

      expect(response).to have_http_status :created
    end

    with_versioning do
      it "audits who created the new enrollment" do
        # TODO: Fix the request-helper that creates a new user every time is initialized
        expect { post url, params: params, headers: admin_headers }.to change { PaperTrail::Version.count } # .by(1)
      end
    end
  end

  context "when the user_id sent is already enrolled to the course" do
    let!(:enrollment) { create :enrollment, course: course }
    let(:enrolled_user) { enrollment.user }

    let!(:params) { { enrollment: { user_id: enrolled_user.id } }.to_json }

    it "does not create a new enrollment, and returns errors on user" do
      expect { post url, params: params, headers: admin_headers }.not_to change { Enrollment.count }

      expect(response).to have_http_status :unprocessable_entity

      expect(response_body["user_id"]).to match ["has already been taken"]
    end
  end

  context "when the user_id sent is invalid" do
    let!(:params) { { enrollment: { user_id: nil } }.to_json }

    it "does not create a new course, and returns errors on user" do
      expect { post url, params: params, headers: admin_headers }.not_to change { Enrollment.count }

      expect(response).to have_http_status :unprocessable_entity

      expect(response_body["user"]).to match ["must exist"]
    end
  end
end
