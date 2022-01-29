RSpec.describe "courses/contents#destroy", type: :request do
  let!(:course) { create :course }

  # TODO: Helper for generating blobs
  let!(:blob) do
    path = file_fixture "videos/sample.mp4"
    io = File.open path, "rb"
    content_type = Marcel::MimeType.for path

    ActiveStorage::Blob.create_and_upload!(io:, content_type:, filename: path.basename)
  end

  let!(:content) { create :content, course: course, file: blob.signed_id }

  def url(course_id: course.id, id: content.id)
    "/courses/#{course_id}/contents/#{id}"
  end

  context "requirements" do
    it "requires authentication" do
      delete url

      expect(response).to have_http_status :unauthorized
    end

    context "authorization" do
      it "only admins can remove contents" do
        delete url, headers: auth_headers

        expect(response).to have_http_status :forbidden
      end
    end

    it "requires the parent resource (course) to exist" do
      delete url(course_id: 0), headers: admin_headers

      expect(response).to have_http_status :not_found
    end

    it "requires the content to exist" do
      delete url(id: 0), headers: admin_headers

      expect(response).to have_http_status :not_found
    end
  end

  context "when the content exists" do
    it "deletes de content and the attached file, responding with :no_content" do
      expect { delete url, headers: admin_headers }
        .to change  { Content.count }.by(-1)
        .and change { ActiveStorage::Attachment.count }.by(-1)


      expect(response).to have_http_status :no_content
    end
  end
end
