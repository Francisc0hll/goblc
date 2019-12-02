class UpdateDgmnIdProcesoSimple < ActiveRecord::Migration[5.0]
  def change
    p = Procedure.find_by(class_name_simple: 'ProcedureCertificadoSituacionMilitar')
    p.update(id_proceso_simple: 1856)
  end
end
