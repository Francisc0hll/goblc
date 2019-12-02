class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_totem
    @current_totem ||= Totem.find_by_tid(cookies[:hostname]) if cookies[:hostname]
  end
  helper_method :current_totem

  def current_rut
    session[:rut]
  end
  helper_method :current_rut

  def current_user
    return if session[:user_id].nil?
    User.find(session[:user_id])
  end

  def authorize
    redirect_to root_url unless current_totem
  end

  def authorized_user
    redirect_to root_url unless current_user
  end

  def clean_session
    session[:rut] = nil
    clean_user_session
    session[:previous_location] = nil
    session[:clave_unica_error] = nil
  end

  def clean_user_session
    session[:user_id] = nil
  end

  def store_current_location
    session[:previous_location] = request.url
  end

  def previous_location
    session[:previous_location]
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
