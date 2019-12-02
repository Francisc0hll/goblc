class Api::V1::ProcedureMonitorsController < Api::V1::BaseController

    swagger_controller :procedure_monitors, 'Procedures Monitoring'


    swagger_api :index do
      summary "Returns all the monitoring info to each Simple procedure"
      notes "This return the state of each Simple procedure"
      response :ok, "Success", :ProcedureMonitor
      response :unauthorized
    end


    swagger_model :ProcedureMonitor do
      description "The result of Simple services monitor"
      property :id_etapa_simple, :string, :required, "Simple 'tarea' id number"
      property :id_proceso_simple, :datetime, :required, "Simple 'proceso' id number"
      property :name, :string, :optional, "The procedure name"
    end

    def index
      mock = {
        "id_etapa_simple" => 19,
        "id_proceso_simple" => 12,
        "name" => 'Certificado de Situación Militar'
      }
      render json: mock, status: :ok
    end
  end
