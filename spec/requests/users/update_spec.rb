RSpec.describe "users#destroy", type: :request do
  let!(:user) { create :user }
  let!(:params) { { user: {} }.to_json }

  def url(id: user.id)
    "/users/#{id}"
  end

  context "requirements" do
    it "requires authentication" do
      put url

      expect(response).to have_http_status :unauthorized
    end

    context "authorization" do
      it "requires user to be an admin" do
        put url, params: params, headers: auth_headers

        expect(response).to have_http_status :forbidden
      end
    end

    it "requires user to exist" do
      put url(id: 0), params: params, headers: admin_headers

      expect(response).to have_http_status :not_found
    end
  end

  context "when the user exists and valid params are used" do
    let!(:params) { { user: { name: "Test" } }.to_json }

    it "updates the existing resource" do
      expect do
        put url, params: params, headers: admin_headers
        user.reload
      end.to change { user.name }

      expect(response).to have_http_status :ok
    end
  end

  context "when the user exists but invalid params are used" do
    let!(:params) { { user: { name: nil } }.to_json }

    it "updates the existing resource" do
      expect do
        put url, params: params, headers: admin_headers
        user.reload
      end.not_to change { user.name }

      expect(response).to have_http_status :unprocessable_entity
      expect(response_body).to have_key "name"
    end
  end
end
