class ClaveUnicasController < ApplicationController
  include ClaveUnicaHelper
  before_action :authorize, :authorized_user, except: [:authenticate, :validate]

  def create
    cu_petition = ClaveUnicaPetition.create(rut: current_user.rut,
      totem: current_totem,
      phone: params[:phone],
      email: params[:mail],
      method: params[:create_method])
    response = ClaveUnica.create(current_user, current_totem.country_phone_code, params)
    puts response
    if response && response.status == 201
      cu_petition.mark_success
      redirect_to success_clave_unicas_path
    elsif response && response.status == 409
      cu_petition.mark_as_already_created
      session[:clave_unica_error] = JSON.parse(response.body)['message']
      redirect_to error_clave_unicas_path
    else
      cu_petition.mark_failure
      session[:clave_unica_error] ||= "Ocurrio un error, intentalo nuevamente"
      #session[:clave_unica_error] = JSON.parse(response.body)['message'] if response.try(:body).present?
      session[:clave_unica_error] ||= 'Tu clave única no pudo ser creada.'
      redirect_to error_clave_unicas_path
    end
  end

  def authenticate
    time_out if params[:error_timeout].present?
  end

  def validate
    cod_resp = validate_user(params[:run], params[:password])
    redirect_to previous_location if cod_resp == "OK"
    rescue RuntimeError => e
      cod_resp = e
      @has_error = true
      @type_error = cod_resp == 'TimeOut' ? "time_out" : "rut_clave"
      render :authenticate
  end

  def alternatives
    redirect_to root_path unless current_user
  end

  def cellphone; end

  def email; end

  def screen; end

  def screen_step2
    @mail = params[:mail]
    @phone = params[:phone]
  end

  def error
    @error = session[:clave_unica_error]
    clean_session
  end

  def success
    clean_session
  end

  def time_out
    @type_error = 'time_out'
    @has_error = true
    render :authenticate
  end
end
