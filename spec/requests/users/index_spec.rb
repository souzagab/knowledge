RSpec.describe "users#index", type: :request do
  let(:url) { "/users" }

  context "requirements" do
    it "requires authentication" do
      get url

      expect(response).to have_http_status :unauthorized
    end

    context "authorization" do
      it "responds with forbidden if user is not an admin" do
        get url, headers: auth_headers

        expect(response).to have_http_status :forbidden
      end

      it "requires user to be an admin" do
        get url, headers: admin_headers

        expect(response).to have_http_status :ok
      end
    end
  end

  context "when there are no existing users" do
    it "responds with :ok status and an empty list" do
      get url, headers: admin_headers

      expect(response).to have_http_status :ok

      expect(response_body).to eq []
    end
  end

  context "when there are users registered" do
    let!(:existing_users) { create_list :user, rand(1...3) }

    it "responds with :ok status with user's list" do
      get url, headers: admin_headers

      expect(response).to have_http_status :ok

      expect(response_body.size).to eq existing_users.size
    end
  end
end
