class UpdateDgmnProcedure < ActiveRecord::Migration[5.0]
  def change
    p = Procedure.find_by(procedure_id: 1856)
    p.update(class_name_simple: 'ProcedureCertificadoSituacionMilitar')
  end
end
