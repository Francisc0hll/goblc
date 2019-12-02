class ProcedureCalidadPensionado< ProcedureSimple
    include RutHelper


    attr_reader :certificate
    attr_reader :error_code
    attr_reader :error_desc

    def initialize
      @certificate = nil
      @error_code = nil
      @error_desc = nil
      @array_prev = []
      @array_rep = []
      @array_pbs = []
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
          required_instance_variables: [ "available_pbs", "available_prev", "available_rep", "id_instancia", "id_etapa", "secuencia"],
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
        "#{CUSTOM_FORM_BASE_ROUTE}calidad_pensionado/calidad_pensionado_first",
       # choose payment id
        "#{CUSTOM_FORM_BASE_ROUTE}calidad_pensionado/calidad_pensionado_list",
       #choose to print or to send to email
        "#{CUSTOM_FORM_BASE_ROUTE}calidad_pensionado/calidad_pensionado_third_step"
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
    def gather_benefit_info(index, benefit, benefit_type, selection)
      {
        nombre: benefit["institucionLey"],
        tipopension: benefit["tipoPension"],
        beneficio: benefit_type,
        seleccion: selection,
        posicion: index
      }
    end

    # this method analize response of simple
    def start_step_response_adapter(data_to_process)
      output = data_to_process.dig(:response, :data, 'output')
      contador_prev = output["contador_prev"].to_i
      contador_rep = output["contador_rep"].to_i
      contador_pbs = output["contador_pbs"].to_i
      #analizo la data contenida en salidapbs
      if contador_pbs > 1
        output.dig('salidapbs').each_with_index do |benefit, index|
          return if benefit["numeroDocumento"].to_i == 0
          @array_pbs << gather_benefit_info(index + 1, benefit, 'Basica Solidaria', 'seleccion_pbs_a')
        end
      elsif output["salidapbs"]["numeroDocumento"].to_i != 0
        @array_pbs << gather_benefit_info(1, output["salidapbs"], 'Basica Solidaria', 'seleccion_pbs_s')
      end
      # analiza la data contenida en salidarep
      if contador_rep.to_i > 1
        output.dig('salidarep').each_with_index do |benefit, index|
          return if benefit["numeroDocumento"].to_i == 0
          @array_rep << gather_benefit_info(index + 1, benefit, 'Reparacion', 'seleccion_rep_a')
        end
      elsif output["salidarep"]["numeroDocumento"].to_i != 0
        @array_rep << gather_benefit_info(1, output["salidarep"], 'Reparacion', 'seleccion_rep_s')
      end
      #analiza la data contenida en salidaprev
      if contador_prev.to_i > 1
        output.dig('salidaprev').each_with_index do |benefit, index|
          return if benefit["numeroDocumento"].to_i == 0
          @array_prev << gather_benefit_info(index + 1, benefit, 'Previsional', 'seleccion_prev_a')
        end
      elsif output["salidaprev"]["numeroDocumento"].to_i != 0
        @array_prev << gather_benefit_info(1, output["salidaprev"], 'Previsional', 'seleccion_prev_s')
      end
      { available_pbs: @array_pbs, available_prev: @array_prev, available_rep: @array_rep }
    end

    def start_step_request_pipeline(params)
      adapters = [

        method(:identification_hash),
        method(:request_sequence_data)
      ]
      start_params = adapters.reduce({}) do |acc, adapter|
                       acc.merge(adapter.call(params))
                     end
      start_procedure(start_params)
    end
    #se recibe la respuesta desde simple
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
      {
        data: {
        "seleccion_prev_a" => params[:seleccion_prev_a]  || [],
        "seleccion_pbs_s"   => params[:seleccion_pbs_s]   || [],
        "seleccion_rep_s"   => params[:seleccion_rep_s]   || [],
        "seleccion_prev_s"  => params[:seleccion_prev_s]  || [],
        "seleccion_pbs_a"   => params[:seleccion_pbs_a]   || [],
        "seleccion_rep_a"   => params[:seleccion_rep_a]   || []
        }
      }
    end

    def second_step_response_adapter(data_to_process)
      {
        form_view: "calidad_pensionado/calidad_pensionado_third_step",
        certificate_base64: append_pdf(data_to_process),
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
        method(:second_step_response_adapter)
      ]

      adapters.reduce({}) do |acc, adapter|
        acc.merge(adapter.call(data_to_process))
      end
    end
    ##### third step methods
    #####
    def third_step_data_adapter(_params)
      {
        data: { }
      }
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
      #metodos que recorre el output y busca los
    def append_pdf(data_to_process)
        certfinal = []
        data = data_to_process[:response][:data]["output"]
        data.each do |attr_value|
            attr_value.each do |tag|
              if is_base64(tag.to_s) && tag.length > 100
                  certfinal << tag
              end
            end
        end

      return  merge_pdf(certfinal)
    end

    def is_base64(child)
      /^([A-Za-z0-9+\/]{4})*([A-Za-z0-9+\/]{4}|[A-Za-z0-9+\/]{3}=|[A-Za-z0-9+\/]{2}==)$/.match(child)
    end

    def merge_pdf(base)


        pdf = CombinePDF.new
        if base.length.to_i > 1
            base.each_with_index do |subchild,index|
              file = Tempfile.new( "#{index}.pdf", :encoding => 'utf-8')
                File.open(file, 'wb') do |f|
                    f.write(Base64.decode64(subchild))
                end
                pdf << CombinePDF.load(file.path)
            end
              pdf.save "final_certificate.pdf"
              Base64.encode64(File.read("final_certificate.pdf"))
        elsif base.length.to_i == 1

            return base
        end


    end

end



