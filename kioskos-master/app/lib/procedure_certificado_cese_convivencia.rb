class ProcedureCertificadoCeseConvivencia < ProcedureSimple
    include RutHelper
  
    attr_reader :certificate
    attr_reader :error_code
    attr_reader :error_desc
  
    def initialize
      @certificate = nil
      @error_code = nil
      @error_desc = nil
    end
  
    def process_procedure(params)
      params_iniciar = {
        _id_proceso_tramite_: params[:_id_proceso_tramite_],
        _id_tarea_etapa_: params[:_id_tarea_etapa_],
        identificacion: {
          rut: add_dashes(params[:rut]),
          nombres: params[:name] || '',
          apellidos: "#{params[:last_name_father] || ''};#{params[:last_name_mother] || ''}",
          email: params[:email] || ''
        },
        data: {
        }
      }
      resp = start_procedure(params_iniciar)
      data = resp[:data]
      @process_status = data["estadoProceso"]
      @error_desc = data["output"]["errorDescripcion"]
      if (@process_status != 'finalizado')
        idInstancia = resp[:data]['idInstancia']
        idEtapa = resp[:data]['proximoFormulario'][0]['form']['idEtapa']
        secuencia = resp[:data]['secuencia']
        params_continuar = {
          _id_proceso_tramite_: idInstancia,
          _id_tarea_etapa_: idEtapa,
          _secuencia_: secuencia,
          identificacion: {
            rut: add_dashes(params[:rut]),
            nombres: params[:name] || '',
            apellidos: "#{params[:last_name_father] || ''};#{params[:last_name_mother] || ''}",
            email: params[:email] || ''
          },
          data: {}
        }
        resp = continue_procedure(params_continuar)
      end
      @error_code = 1
      @error_desc = resp[:error]
      return if @error_desc.present?
  
      @certificate = resp[:data]['output']['certceseconvivencia']
      @error_code = resp[:data]['output']['errorCodigo']
      @error_desc = resp[:data]['output']['errorDescripcion']
      @certificate = nil if @error_code.to_i == 1
      puts "@process_status: #{@processStatus}"
      puts "@error_code: #{@error_code}"
      puts "@error_desc: #{@error_desc}"
      puts "@certificate: #{@certificate}"
    end
  
  end
  