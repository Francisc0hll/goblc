class HomeController < ApplicationController
  include ClaveUnicaHelper

  def index
    if params[:error_timeout].present?
      time_out
    else
      redirect_to totem_path if current_totem
    end
  end
end
