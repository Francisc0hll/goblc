class ProcedurePrueba < ProcedureSimple

  attr_reader :certificate
  attr_reader :error_code
  attr_reader :error_desc

  def initialize
    @certificate = nil
    @error_code = nil
    @error_desc = nil
  end

  def process_procedure(params)
    @error_code = 0
    @certificate = 'ok'
  end

  def custom_form
    'procedure_prueba'
  end

end
