class Api::V1::TotemMonitorsController < Api::V1::BaseController

  skip_before_action :verify_authenticity_token, only: [:create, :index]

  swagger_controller :totem_monitors, 'Totem Monitoring Managment'


  swagger_api :index do
    summary "Returns all the monitoring info to each Totem"
    notes "This lists all the totems monitoring or the monitoring register to the specific totem"
    param :form, :totem_tid, :string, :optional, "Totem id"
    response :ok, "Success", :TotemMonitor
    response :unauthorized
  end

  swagger_api :create do
    summary "Create or update the totem monitoring register"
    notes "A new register is create if there is no record for that totem_tid"
    response :ok, "Success", :TotemMonitor
    response :unauthorized
    response :unprocessable_entity
    param :form, :totem_tid, :string, :required, "Totem id"
    param :form, :ping_date, :datetime, :required, "client ping date and time in ISO format"
  end

  swagger_model :TotemMonitor do
    description "A Totem monitoring register."
    property :totem_tid, :string, :required, "Totem Id"
    property :ping_date, :datetime, :required, "client ping Date time in ISO format"
  end
  def index
    if(params[:totem_tid].present?)
      render json: TotemMonitor.where(totem_tid: params[:totem_tid]), status: :ok
    else
      render json: TotemMonitor.all, status: :ok
    end
  end

  def create  
    totem_monitor = TotemMonitor.find_or_create_by(totem_tid: monitor_params[:totem_tid]) do |monitor|
      monitor.ping_time = monitor_params[:ping_time]   
    end
    response.set_header('Access-Control-Allow-Origin', '*')
    totem_monitor.ping_time = monitor_params[:ping_time]
    if totem_monitor.save
        render json: totem_monitor.to_json
    else
        render json: { errors: totem_monitor.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  def monitor_params
    params.permit(:totem_tid, :ping_time)
  end
end
