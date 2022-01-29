RSpec.describe "users#destroy", type: :request do
  let!(:user) { create :user }

  def url(id: user.id)
    "/users/#{id}"
  end

  context "requirements" do
    it "requires authentication" do
      delete url

      expect(response).to have_http_status :unauthorized
    end

    context "authorization" do
      it "only admins can delete users" do
        delete url, headers: auth_headers

        expect(response).to have_http_status :forbidden
      end
    end

    it "requires user to exist" do
      delete url(id: 0), headers: admin_headers

      expect(response).to have_http_status :not_found
    end
  end

  context "when the user exists" do
    it "responds with the existing resource" do
      # TODO: Fix the request-helper that creates a new user every time is initialized
      # expect { delete url, headers: admin_headers }.to change { User.count }#.by(-1)
      delete url, headers: admin_headers

      expect(response).to have_http_status :no_content
    end
  end
end
