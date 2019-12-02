class TotemsController < ApplicationController
  before_action :authorize, :clean_session

  def index
    @totem = current_totem
  end
end
