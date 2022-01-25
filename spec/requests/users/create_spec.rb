RSpec.describe "users#create", type: :request do
  let(:url) { "/users" }
  let(:user_attributes) { attributes_for :user }
  let(:params) { { user: user_attributes }.to_json }
  let!(:headers) { admin_headers }

  context "requirements" do

    it "requires authentication" do
      post url, params: params

      expect(response).to have_http_status :unauthorized
    end

    context "authorization" do
      it "requires user to be an admin" do
        post url, params: params, headers: auth_headers

        expect(response).to have_http_status :forbidden
      end
    end
  end

  context "when all params sent are valid" do

    it "creates a new user" do
      expect { post url, params: params, headers: admin_headers }.to change { User.count }

      expect(response).to have_http_status :created
    end
  end

  context "when one or more parameters sent are invalid" do
    let!(:user_attributes) { attributes_for :user, :invalid }

    it "does not create a new user, and returns errors" do
      # TODO: Fix the request-helper that creates a new user every time is initialized
      # expect { post url, params: params, headers: admin_headers }.not_to change { User.count }
      post url, params: params, headers: admin_headers

      expect(response).to have_http_status :unprocessable_entity

      expect(response_body).to have_key "email"
    end
  end
end
