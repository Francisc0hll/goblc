class ProceduresController < ApplicationController
  before_action :authorize
  def index
    @procedures = Procedure.list_procedures
  end

  def search
    @procedures = Procedure.search_procedures(params[:search], params[:next_token])
    register_search
    render :js, file: 'procedures/search.js.erb'
  end

  def show
    @procedure = Procedure.get_info(params[:id])
    flash.now[:show_toast] = true if Procedure.chile_atiende_ids.include? @procedure['id'].to_i
    register_procedure
  end

  def send_info
    @procedure = Procedure.get_info(params[:id])
    ProcedureMailer.send_info(params[:email], @procedure).deliver
    render :js, file: 'procedures/send_info.js.erb'
  end

  def register_search
    return if params[:next_token].present?
    results = @procedures.try(:pluck, 'titulo').try(:join, ', ')
    SearchProcedureLog.create(search: params[:search],
                              found: @procedures.present?,
                              totem: current_totem,
                              results: results)
  end

  def register_procedure
    return if @procedure.blank?
    ProcedureLog.create(name: @procedure['titulo'],
                        chileatiende_id: @procedure['id'],
                        totem: current_totem)
  end
end
