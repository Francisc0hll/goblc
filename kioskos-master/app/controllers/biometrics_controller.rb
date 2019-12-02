class BiometricsController < ApplicationController
  before_action :authorize, except: [:register_event]
  skip_before_action :verify_authenticity_token, only: [:register_event]
  include SecurityHelper

  def index; end

  def intro; end

  def step_two; end

  def validate_result
    user_info = params['user_info']
    result = false
    if params['event'] == 'autenticacion' && user_info['error'].nil? && verify_signature(user_info, current_totem)
      result = true
      register_user(user_info)
    end
    respond_to do |format|
      format.json { render json: [result: (user_info['resultado'] == "true" && result), previus: previous_location] }
    end
  end

  def register_event
    totem = Totem.find_by(tid: params[:idTotem])
    if totem.present? && request.raw_post.present? && verify_signature(JSON.parse(request.raw_post), totem)
      transaction = MatchOnCardTransaction.new(totem: totem, event_json: request.raw_post)
      respond_to do |format|
        if transaction.save!
          format.json { render json: [status_code: Rack::Utils.status_code(:ok), status_message: 'OK'], status:  :ok}
        else
          format.json { render json: [
            status_code: Rack::Utils.status_code(:internal_server_error),
            status_message: 'No se pudo guardar el evento'
          ], status:  :internal_server_error}
        end
      end
    else
      respond_to do |format|
        format.json { render json: [
          status_code: Rack::Utils.status_code(:unauthorized),
          status_message: 'No está autorizado'
        ], status: :unauthorized }
      end
    end
  end

  private

  def register_user(user_info)
    user = User.find_by(rut: user_info['rut'].tr('.-', ''))
    user&.update(name: user_info['nombre'])
    user = User.new(rut: user_info['rut'], name: user_info['nombre']) if user.nil?
    user.assign_totem(current_totem)
    user.save!
    Authentication.create!(
      user_id: user.id, auth_type: 'match_on_card',
      finger: user_info['dedo'], minucia: user_info['minucia'],
      totem_id: current_totem.id
    )
    session[:user_id] = user.id
    session[:rut] = user.rut
  end
end
