RSpec.describe "Users", type: :request do

  describe "GET /index" do
    let(:url) { "/users" }

    context "requirements" do
      it "requires authentication" do
        get url

        expect(response).to have_http_status :unauthorized
      end

      context "authorization" do
        let(:headers) { auth_headers(role: :admin) }

        it "responds with forbidden if user is not an admin" do
          get url, headers: auth_headers

          expect(response).to have_http_status :forbidden
        end

        it "requires user to be an admin" do
          get url, headers: headers

          expect(response).to have_http_status :ok
        end
      end

      context "when there are no existing users" do
        let(:headers) { auth_headers(role: :admin) }

        it "responds with :ok status and an empty list" do
          get url, headers: headers

          expect(response).to have_http_status :ok

          response_body = JSON.parse(response.body)

          expect(response_body).to eq []
        end
      end

      context "when there are users registered" do
        let(:headers) { auth_headers(role: :admin) }
        let!(:existing_users) { create_list :user, rand(1...3) }

        it "responds with :ok status with user's list" do
          get url, headers: headers

          expect(response).to have_http_status :ok

          response_body = JSON.parse(response.body)

          expect(response_body.size).to eq existing_users.size
        end
      end
    end
  end
end
