class ProcedureSimple
  include ActionView::Helpers::TagHelper
  include ActionView::Context

  BASE_URL = 'http://simple-cer.digital.gob.cl'.freeze
  CUSTOM_FORM_BASE_ROUTE = 'custom_forms_simple/'.freeze
  
  def no_error?
    error_code.to_i.zero?
  end

  def get_json(url)
    conn = Faraday.new(url: BASE_URL)
    response = conn.get url, type: 'JSON'
    JSON.parse(response.body)
  end

  def get_procedure_info(id_proceso, id_tarea)
    procesos_array = get_json('integracion/especificacion/procesos')
    procesos_array['catalogo'].find { |p| p["URL"].end_with?("proceso/#{id_proceso}/tarea/#{id_tarea}") }
  end

  def get_form_fields(id_proceso_tramite, id_tarea_etapa, paso = nil)
    new_url = "integracion/especificacion/formularios/proceso/#{id_proceso_tramite}/tarea/#{id_tarea_etapa}"
    new_url << "/paso/#{paso}" unless paso.nil?
    json = get_json(new_url)
    json.first['form']['campos']
  end

  def get_initial_form(id_procedure, id_proceso_tramite, id_tarea_etapa, paso = nil, route = '')
    fields = get_form_fields(id_proceso_tramite, id_tarea_etapa, paso)
    build_form(id_procedure,
               id_proceso_tramite,
               id_tarea_etapa,
               nil,
               fields,
               route)
  end

  def start_procedure(params)
    #id del proceso en simple
    raise ArgumentError, '_id_proceso_tramite_ is required' if params[:_id_proceso_tramite_].nil?
    #id de la tarea en simple
    raise ArgumentError, '_id_tarea_etapa_ is required' if params[:_id_tarea_etapa_].nil?
    id_proceso = params[:_id_proceso_tramite_]
    id_tarea = params[:_id_tarea_etapa_]
    conn = Faraday.new(url: "#{BASE_URL}/integracion/api/tramites/proceso/#{id_proceso}/tarea/#{id_tarea}",
                       ssl: { verify: false })

    params.delete(:_id_proceso_tramite_)
    params.delete(:_id_tarea_etapa_)

    puts "#{BASE_URL}/integracion/api/tramites/proceso/#{id_proceso}/tarea/#{id_tarea}"
    puts "params: #{params.to_json}"

    response = conn.post do |req|
      req.body = params.to_json
      req.headers['cache-control'] = 'no-cache'
      req.headers['Content-Type'] = 'application/json'
      req.options.timeout = 60
      req.options.open_timeout = 60
    end

    json = parse_json(response.body)
    if json['proximoFormulario'].nil?
      puts "Respuesta desde simple: #{response.body}"
      Rollbar.error(response.body)
      raise RuntimeError, "El sistema no ha entregado una respuesta"
    end

    {data: json, error: nil}

    rescue Faraday::Error::ConnectionFailed, Faraday::TimeoutError => e
      Rollbar.error(e)
      {data: nil, error: 'El sistema no ha respondido dentro del tiempo esperado'}
    rescue RuntimeError => e
      Rollbar.error(e)
      {data: nil, error: e}
  end

  def continue_procedure(params)
    #id del proceso en simple
    raise ArgumentError, '_id_proceso_tramite_ is required' if params[:_id_proceso_tramite_].nil?
    #id de la tarea en simple
    raise ArgumentError, '_id_tarea_etapa_ is required' if params[:_id_tarea_etapa_].nil?
    #secuencia del tramite en simple
    raise ArgumentError, '_secuencia_ is required' if params[:_secuencia_].nil?
    id_tramite = params[:_id_proceso_tramite_] #id de la instancia del proceso "el tramite" en simple
    id_etapa = params[:_id_tarea_etapa_] #id de la instancia de la tarea "la etapa" en simple
    secuencia = params[:_secuencia_]

    params.delete(:_id_proceso_tramite_)
    params.delete(:_id_tarea_etapa_)
    params.delete(:_secuencia_)

    puts "#{BASE_URL}/integracion/api/tramites/tramite/#{id_tramite}/etapa/#{id_etapa}/paso/#{secuencia}"
    puts "params: #{params.to_json}"

    conn = Faraday.new(url: "#{BASE_URL}/integracion/api/tramites/tramite/#{id_tramite}/etapa/#{id_etapa}/paso/#{secuencia}",
                       ssl: { verify: false })

    response = conn.put do |req|
      req.body = params.to_json
      req.headers['cache-control'] = 'no-cache'
      req.headers['Content-Type'] = 'application/json'
      req.options.timeout = 60
      req.options.open_timeout = 60
    end

    json = parse_json(response.body)
    if json['proximoFormulario'].nil?
     puts "Respuesta desde simple: #{response.body}"
     Rollbar.error(response.body)
     raise RuntimeError, "El sistema no ha entregado una respuesta"
    end

    {data: json, error: nil}

   rescue Faraday::Error::ConnectionFailed, Faraday::TimeoutError => e
     Rollbar.error(e)
     {data: nil, error: 'El sistema no ha respondido dentro del tiempo esperado'}
   rescue RuntimeError => e
     Rollbar.error(e)
     {data: nil, error: e}
  end

  def process_procedure(resp)
    raise 'SYSTEM ERROR: method missing'
  end

  def build_form(id_procedure, id_proceso_tramite, id_tarea_etapa, secuencia, fields, route = '')
    id_element = content_tag('input', id_procedure, type: 'hidden', readonly: true, name: 'id').html_safe
    id_proceso_tramite_element = content_tag('input', id_proceso_tramite, type: 'hidden', readonly: true, name: '_id_proceso_tramite_').html_safe
    id_tarea_etapa_element = content_tag('input', id_tarea_etapa, type: 'hidden', readonly: true, name: '_id_tarea_etapa_').html_safe
    secuencia_element = content_tag('input', secuencia, type: 'hidden', readonly: true, name: '_secuencia_').html_safe
    form_contents = fields.map(&method(:create_field_from_hash)).join.html_safe
    submit_button = content_tag('button', 'Enviar', type: 'submit')

    content_tag('form', form_contents, class: 'simple-form', action: route) do
      id_element << id_proceso_tramite_element << id_tarea_etapa_element <<
        secuencia_element << form_contents << submit_button
    end.html_safe
  end

  def create_field_from_hash(field_hash)
    # Ejemplo "field_hash" =>
    # {
    #   "nombre":"rut",
    #   "tipo_control":"text",
    #   "tipo":"string",
    #   "obligatorio":false,
    #   "solo_lectura":false,
    #   "dominio_valores":null,
    #   "valor":""
    #   }

    option_values = field_hash['dominio_valores']

    field_label = content_tag('label', field_hash['nombre']).html_safe

    field_opts = { type: 'text',
                   required: field_hash['obligatorio'],
                   readonly: field_hash['solo_lectura'],
                   value: field_hash['value'],
                   name: field_hash['nombre']
                 }
    if option_values then create_select(field_label, field_hash, field_opts)
    else field_label << content_tag('input', field_opts[:value], field_opts).html_safe
    end
  end

  def create_select(field_label, field_hash, field_opts)
    select_tag = content_tag('select', field_hash[:value], field_opts) do
                   content_tag(:optgroups, label: 'options') do
                     field_hash['dominio_valores'].map(&method(:create_option_tag))
                                                  .join
                                                  .html_safe
                   end
                 end
    field_label << select_tag
  end

  def create_option_tag(value)
    content_tag('option', value, value: value)
  end

  def parse_json(json)
    JSON.parse(json)
  rescue JSON::ParserError => e
    {}
  end
end
