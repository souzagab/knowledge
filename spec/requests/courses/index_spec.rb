RSpec.describe "courses#index", type: :request do
  let(:url) { "/courses" }

  context "requirements" do
    it "requires authentication" do
      get url

      expect(response).to have_http_status :unauthorized
    end
  end

  context "when there are no existing courses" do
    it "responds with :ok status and an empty list" do
      get url, headers: admin_headers

      expect(response).to have_http_status :ok

      expect(response_body).to eq []
    end
  end

  context "when there are courses registered" do
    let!(:existing_courses) { create_list :course, rand(3...5) }

    context "and the user is not a admin" do
      let!(:user) { create :user }
      let!(:headers) { auth_headers_for user }

      context "when the user does not have any enrollments" do
        it "responds with :ok status and an empty list" do
          get url, headers: headers

          expect(response).to have_http_status :ok

          expect(response_body).to eq []
        end
      end

      context "when the user is enrolled in some courses" do
        let(:enrolled_courses) { existing_courses.take rand(1...3) }

        before do
          enrolled_courses.each do |course|
            create :enrollment, course: course, user: user
          end
        end

        it "responds with :ok status with only the courses with enrollments" do
          get url, headers: headers

          expect(response).to have_http_status :ok

          expect(response_body.size).to eq enrolled_courses.size

          course_ids = response_body.pluck "id"
          expect(course_ids).to match_array enrolled_courses.pluck(:id)
        end
      end
    end

    context "and the user is an admin" do
      it "responds with :ok status with all courses" do
        get url, headers: admin_headers

        expect(response).to have_http_status :ok

        expect(response_body.size).to eq existing_courses.size
      end
    end
  end
end
