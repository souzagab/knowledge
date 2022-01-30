# Workaround for DisabledSessionError
# See the devise issue to know more
# refs:  https://github.com/heartcombo/devise/issues/5443#issuecomment-1009779292
module RackSessionsFix
  extend ActiveSupport::Concern

  # :nodoc:
  class FakeRackSession < Hash
    def enabled?()= false
  end

  included do
    before_action :set_fake_session

    private

    def set_fake_session
      request.env["rack.session"] ||= FakeRackSession.new
    end
  end
end
