class CertificatesController < ApplicationController
  before_action :authorize
  before_action :check_params, only: [:create]



  def index
    clean_user_session
    @procedures = Procedure.certificates.actives.search_by_name(params[:search])
    # Render the partial if params[:search] is given, otherwise render the full index view
    return render partial: 'procedure_list' if params[:search]
  end

  def show
    @procedure = Procedure.find(params[:id])
    session[:certificate] = nil
    procedure_instance = @procedure.class_name_simple.constantize.new
    @form_view = # procedure_instance.custom_form if procedure_instance.respond_to?(:custom_form)
      if procedure_instance.respond_to? :custom_form
        procedure_instance.custom_form
      elsif procedure_instance.respond_to? :custom_forms
        procedure_instance.custom_forms.first
      end

    if params[:socket] == "false" && @procedure.require_authentication? && current_user.blank?
      # ignore query params or end up in an infinite loop
      session[:previous_location] = request.url.split("?")[0]
      return redirect_to authenticate_clave_unicas_path
    end
    if @procedure.require_authentication? && current_user.blank?
      store_current_location
      return redirect_to intro_identity_validation_certificates_path
    end
    return render @form_view unless @procedure.simple?
  end

  def create
    @procedure = Procedure.find(params[:id])
    rut = params[:rut] || current_rut
    @mail = params[:email]
    certificate = Certificate.create!(procedure: @procedure, rut: rut, email: @mail,totem_id: current_totem.tid)
    if @procedure.class_name_simple.present?
      user = User.find_by(rut: rut)
      fill_params!(params, rut, @procedure, user)
      case @procedure.simple?
      when true then process_simple_procedure(@procedure, certificate, params)
      when false then process_other(@procedure, certificate, params)
      end
    else
      render 'no_certificate'
    end
  rescue => e
   Rollbar.error(e)
   @error_desc = 'Error inesperado'
   render 'no_certificate'
   clean_session
  end

  def create_complex

  end

  def process_simple_procedure(procedure, certificate, params)
    procedure.increase_request_count
    procedure_instance = procedure.class_name_simple.constantize.new
    procedure_instance.process_procedure(params)
    # If we receive a certificate, choose to print it or to send it to the
    # user's email.
    if procedure_instance.certificate.present?
      send_by_email = params[:send_by_email] == 'true'
      return send_certificate_by_email(procedure_instance, certificate) if send_by_email
      print_certificate(procedure_instance, certificate)
    else
      certificate.mark_failure
      @error_desc = procedure_instance.error_desc
      render 'no_certificate'
    end
  end

  def process_other(procedure, certificate, params)
    procedure_instance = procedure.class_name_simple.constantize.new
    current_step_index = params['procedure_step'].to_i
    current_step_handler = procedure_instance.steps[current_step_index]
    next_step_handler = procedure_instance.steps[current_step_index + 1]

    #### Execute current step!!
    current_step_response = current_step_handler[:request_pipe].call(params)

    #### Get whatever is required for the next step from either the response from SIMPLE or from
    #### the params we received, since these are sometimes dependant

    data_to_process = {
      response: current_step_response,
      params: params,
      procedure: procedure,
      procedure_instance: procedure_instance,
      certificate: certificate,
      controller: self
    }

    next_step_required_data = current_step_handler[:response_pipe].call(data_to_process) #(data_for_processing)

    return if next_step_handler.nil?

    next_step_handler[:required_instance_variables].each do |param|
      instance_variable_set("@#{param}", next_step_required_data[param.to_sym])
    end unless next_step_handler.nil?

    next_form = next_step_handler[:form]
    @procedure_step = current_step_index + 1

    #### Render the next step's form, whichever that is (if it exists!)
    render next_form if next_form
  end


  def send_certificate_by_email(procedure_instance, certificate)
    send_mail(procedure_instance.certificate)
    certificate.mark_success
    @error_desc =
      if procedure_instance.no_error?
        'Tu certificado ha sido enviado al correo electrónico'
      else
        procedure_instance.error_desc
      end
  end

  def send_mail(certificate_base64)

    pdf = Base64.decode64(certificate_base64)
    pdf_name = [@procedure.name.tr(' ', '_').delete(' '), '.pdf'].join
    @procedure.update_delivery_count
    CertificateMailer.send_pdf(@mail, pdf, pdf_name, "Tu #{@procedure.name}").deliver
  end

  def print_certificate(procedure_instance, certificate) 
    send_mail(procedure_instance.certificate)   
    @certificate_base64 = procedure_instance.certificate    
    certificate.mark_success
    @error_desc = if procedure_instance.no_error?
                    'Tu certificado ha sido enviado a la impresora'
                  else # will be printed instead
                    procedure_instance.error_desc
                  end
    render 'print_certificate'
  end

  def fill_params!(params, rut, procedure, user)
    params[:rut] = rut
    params[:name] = user&.name || ''
    params[:last_name_father] = user&.last_name_father || ''
    params[:last_name_mother] = user&.last_name_mother || ''
    params[:_id_proceso_tramite_] = procedure.id_proceso_simple
    params[:_id_tarea_etapa_] = procedure.id_etapa_simple
  end

  def create_session
    session[:rut] = params[:id]
    redirect_to certificates_path
  end

  def success; end

  def intro_identity_validation; end

  def biometric_validation; end

  def biometric_validation_step_two; end

  def field_examples; end


  def time_out
    @type_error = 'time_out'
    @has_error = true
    render :rut
  end

  private

  def check_params
    if params[:email].blank?
      redirect_to certificate_path(params[:id])
      nil
    end
  end
end
