RSpec.describe "Pings", type: :request do
  describe "show - GET /ping" do
    let(:url) { "/ping" }

    it "responds with pong if the app is healthy" do
      get url

      expect(response).to have_http_status :ok

      response_body = JSON.parse(response.body)

      expect(response_body).to have_key "pong"

      pong = DateTime.parse response_body["pong"]
      expect(pong).to be_within(5.seconds).of(DateTime.current)
    end
  end
end
