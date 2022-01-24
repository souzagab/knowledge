RSpec.describe "Registrations", type: :request do
  let(:url) { "/signup" }

  describe "#create - POST /signup" do
    context "when some of the attributes sent are invalid" do
      let(:user_attributes) { attributes_for :user, :invalid }
      let(:params) { { user: user_attributes }.as_json }

      it "responds :unprocessable_entity with errors" do
        expect { post url, params: params }.not_to change { User.count }

        expect(response).to have_http_status :unprocessable_entity
      end
    end

    context "when all user attributes are valid" do
      let(:user_attributes) { attributes_for :user }
      let(:params) { { user: user_attributes }.as_json }

      it "responds :created with user object" do
        expect { post url, params: params }.to change { User.count }.by(1)

        expect(response).to have_http_status :created
      end
    end
  end
end
