class UpdateCertificadoSituacionMilitarProcedure < ActiveRecord::Migration[5.0]
  def change
    execute "UPDATE procedures SET id_proceso_simple=12, id_etapa_simple=19 WHERE name='Certificado de Situación Militar';"
  end
  def down
    execute "UPDATE procedures SET id_proceso_simple=1856, id_etapa_simple=NULL WHERE name='Certificado de Situación Militar';"
  end
end
