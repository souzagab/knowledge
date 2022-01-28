# TODO: Contents render all attachments, find a way to optmize the query
RSpec.describe "courses/contents#index", :without_bullet, type: :request do
  let!(:course) { create :course }

  def url(course_id: course.id)
    "/courses/#{course_id}/contents"
  end

  def blob_for_content
    path = file_fixture "videos/sample.mp4"
    io = File.open path, "rb"
    content_type = Marcel::MimeType.for path

    ActiveStorage::Blob.create_and_upload!(io:, content_type:, filename: path.basename).signed_id
  end

  context "requirements" do
    it "requires authentication" do
      get url

      expect(response).to have_http_status :unauthorized
    end

    context "authorization" do
      let!(:contents) { create_list :content, rand(1...3), course: course, file: blob_for_content }

      it "user can only see contents of enrolled courses" do
        get url, headers: auth_headers

        expect(response).to have_http_status :ok
        expect(response_body).to eq []
      end
    end

    it "requires parent resource (course) to exist" do
      get url(course_id: 0), headers: admin_headers

      expect(response).to have_http_status :not_found
    end
  end

  context "when there are no contents for the course" do
    it "responds with :ok status and an empty list" do
      get url, headers: admin_headers

      expect(response).to have_http_status :ok

      expect(response_body).to eq []
    end
  end

  context "when there are contents for the course" do
    let!(:contents) { create_list :content, rand(1...3), course: course, file: blob_for_content }

    it "responds with :ok status with courses's list" do
      get url, headers: admin_headers

      expect(response).to have_http_status :ok

      expect(response_body.size).to eq contents.size
    end
  end
end
