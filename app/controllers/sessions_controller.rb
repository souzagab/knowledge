# Sessions controller (devise patch)
class SessionsController < Devise::SessionsController
  include RackSessionsFix

  respond_to :json
end
