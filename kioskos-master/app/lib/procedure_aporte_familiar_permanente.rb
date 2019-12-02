class ProcedureAporteFamiliarPermanente < ProcedureSimple
  include RutHelper

  attr_reader :certificate
  attr_reader :error_code
  attr_reader :error_desc

  def initialize
    @certificate = nil
    @error_code = nil
    @error_desc = nil
    @id_instancia = nil
    @id_etapa = nil
    @secuencia = nil
  end

  def steps
    [
      {
        request_pipe: method(:start_step_request_pipeline),
        response_pipe: method(:start_step_response_pipeline),
        form: custom_forms.first
      },
      { request_pipe: method(:second_step_request_pipeline),
        response_pipe: method(:second_step_response_pipeline),
        required_instance_variables: ["numeropago","glosa","statusMensaje" ,"id_instancia", "id_etapa", "secuencia"],
        form: custom_forms.second },
      {
        request_pipe: method(:third_step_request_pipeline),
        response_pipe: method(:third_step_response_pipeline),
        required_instance_variables: [
                                      "form_view", "id_instancia", "id_etapa",
                                      "secuencia", "certificate_base64",
                                      "error_codigo", "error_descripcion"
                                     ],
        form: custom_forms.third }
       ]
  end

  def custom_forms
    [
    # choose date
      "#{CUSTOM_FORM_BASE_ROUTE}aporte_familiar_permanente/aporte_familiar_permanente_start",
     # choose payment id
      "#{CUSTOM_FORM_BASE_ROUTE}aporte_familiar_permanente/aporte_familiar_permanente_second_step",
     #choose to print or to send to email
      "#{CUSTOM_FORM_BASE_ROUTE}aporte_familiar_permanente/aporte_familiar_permanente_third_step"
    ]
  end

  def identification_hash(params)
    { identificacion:
      {
        rut: add_dashes(params[:rut]),
        nombres: params[:name] || '',
        apellidos: "#{params[:last_name_father] || ''};#{params[:last_name_mother] || ''}",
        email: params[:email] || ''
      }
    }
  end

  ################### start step methods
  ###################
  def start_step_data_adapter(params)
    day, month, year = params[:birth_date].split('-')

    # Naive validation for "day" - Doesn't consider month lengths
    raise 'Error formato fecha (dias)' unless day.to_i.between?(1, 31)
    raise 'Error formato fecha (mes)' unless month.to_i.between?(1, 12)
    raise 'Error formato fecha (año)' unless year.to_i.between?(999, 9999)

    # Will be changed later -- to YYYY-MM-DD
    final_date = [year, month, day].join #('-') uncomment this when that change happens
    { data: { fecha: final_date } }
  end

  def start_step_response_adapter(data_to_process)
      mensajeWS = data_to_process.dig(:response,:data,'output','respuesta_ws','mensajeBeneficio')
      glosa = mensaje_status(data_to_process.dig(:response,:data,'output','respuesta_ws','mensajeBeneficio'))
      if mensajeWS  == nil
        msj = false

      else
        msj = true

      end

      {numeropago: data_to_process[:response][:data]["output"]["numeropago"], glosa: glosa , statusMensaje: msj}
  end
  def mensaje_status(data_mensaje)
    if data_mensaje == nil
        mensaje = "%h2 Este año #{Date.current.year}, usted es beneficiario del Aporte Familiar Permanente
        %h2 Este año, usted es beneficiario del Aporte Familiar Permanente #{Date.current.month}, y recibirá XXXXX por cada causante del subsidio o
        %h2 carga familiar debidamente acreditada al 31 de diciembre del #{Date.current.year-1.year}.

        %h2 Su pago total es de XXXXX, el que será incluido en su próxima liquidación de pago, por lo que ustes no debe realizar ningún
        %h2 trámite adicional.

        %h2 El derecho al cobro del benedicio vence impostergablemente a los nueve meses desde la fecha de emisión del pago.

        %h2 Si considera ue el monto pagado no contempla todas sus cargas familiares, usted debe ingresar un reclamo por cada carga
        %h2 familiar faltante, en el sitio web www.aportefamiliar.cl

        %h2 Usted puede revisar el detalle de los pagos que le han sido otorgados, haciendo click en Generar"

    else
      mensaje = data_mensaje
    end
    return mensaje
  end

  def start_step_request_pipeline(params)
    adapters = [
      method(:start_step_data_adapter),
      method(:identification_hash),
      method(:request_sequence_data)
    ]

    start_params = adapters.reduce({}) do |acc, adapter|
                     acc.merge(adapter.call(params))
                   end
    start_procedure(start_params)
  end

  def start_step_response_pipeline(data_to_process)

    adapters = [
      method(:start_step_response_adapter),
      method(:response_sequence_data)
    ]
    adapters.reduce({}) do |curr, adapter|
      curr.merge(adapter.call(data_to_process))
    end
  end


  #####
  ##### second step methods


  def second_step_data(params)
    { data: { numeropago: params['numeropago'] } }
  end

  def second_step_response_adapter(data_to_process)
    {
      form_view: "aporte_familiar_permanente/aporte_familiar_permanente_third_step_custom_form",
      certificate_base64: data_to_process[:response][:data]["output"]["documento_detalle"],
      error_codigo: data_to_process[:response][:data]["output"]["errorCodigo"],
      error_descripcion: data_to_process[:response][:data]["output"]["errorDescripcion"]
    }
  end

  def second_step_request_pipeline(params)

    adapters = [
       method(:continue_request_sequence_data),
       method(:identification_hash),
       method(:second_step_data)
    ]

    continue_params = adapters.reduce({}) do |acc, adapter|
                        acc.merge(adapter.call(params))
                      end
    continue_procedure(continue_params)
  end

  def second_step_response_pipeline(data_to_process)
    adapters = [
      method(:second_step_response_adapter),
      method(:response_sequence_data)
    ]

    adapters.reduce({}) do |acc, adapter|
      acc.merge(adapter.call(data_to_process))
    end
  end

  ##### third step methods
  #####

  def third_step_data_adapter(_params)
    { data: { } }
  end

  def third_step_response_adapter(data_to_process)
    send_by_email = data_to_process[:params]["send_by_email"] == "true"

    certificate_base64 = data_to_process[:params][:_certificate_]
    error_desc = data_to_process[:params][:_error_descripcion].strip

    # this is the Certificate model, which is used for keeping statistics about the certificates that are obtained through the totem
    certificate  = data_to_process[:certificate]
    procedure_instance = data_to_process[:procedure_instance]
    procedure = data_to_process[:procedure]

    mail = data_to_process[:params][:email]

    #### this is a dirty hack -_-
    cert = data_to_process[:controller]

    procedure_instance.instance_variable_set("@certificate", certificate_base64)
    cert.instance_variable_set("@send_by_email", send_by_email)
    cert.instance_variable_set("@certificate", certificate)
    cert.instance_variable_set("@procedure", procedure)
    cert.instance_variable_set("@mail", mail)

    if send_by_email
      cert.send(:send_certificate_by_email, self, certificate)
    else
      cert.send(:print_certificate, self, certificate)
    end

    error_desc = cert.instance_variable_get("@error_desc")
    { send_by_email: send_by_email,
      error_desc: error_desc,
      certificate: certificate,
      certificate_base64: certificate,
      mail: mail }
  end

  def third_step_request_pipeline(params)
    adapters = [
      method(:third_step_data_adapter),
      method(:identification_hash),
      method(:continue_request_sequence_data)
    ]

    continue_params = adapters.reduce({}) do |acc, adapter|
                        acc.merge(adapter.call(params))
                      end
    continue_procedure(continue_params)
  end

  def third_step_response_pipeline(data_to_process)
    adapters = [
      method(:third_step_response_adapter)
    ]
    adapters.reduce({}) do |acc, adapter|
      acc.merge(adapter.call(data_to_process))
    end
  end

  ##### misc methods


  def pagos_info(resp)
    resp[:data]['proximoFormulario'][0]['form']['campos'][0]['valor']
    valor_route = [:data, 'proximoFormulario', 0, 'form', 'campos',0 ,'valor']
    valor = resp.dig(*valor_route).to_json
    JSON.parse(valor, :quirks_mode => true)['pago']
  end

  def request_sequence_data(params)
    hsh = {
            _id_proceso_tramite_: params['_id_proceso_tramite_'],
            _id_tarea_etapa_: params['_id_tarea_etapa_']#['proximoFormulario'][0]['form']['idEtapa']
          }

    hsh[:_secuencia_] = params['_secuencia_'].to_i if params['_secuencia_']
    hsh
  end

  def response_sequence_data(data_to_process)
    {
      id_instancia: data_to_process[:response][:data]['idInstancia'],
      id_etapa: data_to_process[:response][:data]['proximoFormulario'][0]['form']['idEtapa'],
      secuencia: data_to_process[:response][:data]['secuencia']
    }
  end

  def continue_request_sequence_data(params)
    {
      _id_proceso_tramite_: params['_id_instancia_'],
      _id_tarea_etapa_: params['_id_etapa_'],
      _secuencia_: params['_secuencia_']
    }
  end

  # def sequence_info(response_data)
  #   {
  #     id_instancia: response_data['idInstancia'],
  #     id_etapa: response_data['proximoFormulario'][0]['form']['idEtapa'],
  #     secuencia: response_data['secuencia']
  #   }
  # end
end
