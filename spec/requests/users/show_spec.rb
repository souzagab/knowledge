RSpec.describe "users#show", type: :request do
  let!(:user) { create :user }

  def url(id: user.id)
    "/users/#{id}"
  end

  context "requirements" do
    it "requires authentication" do
      get url

      expect(response).to have_http_status :unauthorized
    end

    context "authorization" do
      it "requires user to be an admin" do
        get url, headers: auth_headers

        expect(response).to have_http_status :forbidden
      end
    end

    it "requires user to exist" do
      get url(id: 0), headers: admin_headers

      expect(response).to have_http_status :not_found
    end
  end

  context "when the user exists" do
    it "responds with the existing resource" do
      get url, headers: admin_headers

      expect(response).to have_http_status :ok

      # TODO: Test serialization
      expect(response_body["id"]).to eq user.id
    end
  end
end
