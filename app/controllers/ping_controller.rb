#
# Healthcheck controller
#
class PingController < ApplicationController
  def show
    render json: { pong: DateTime.current }
  end
end
