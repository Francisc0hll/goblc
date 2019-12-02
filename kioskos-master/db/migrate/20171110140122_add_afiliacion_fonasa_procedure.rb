class AddAfiliacionFonasaProcedure < ActiveRecord::Migration[5.0]
  def change
    Procedure.create(
        name: 'Certificado de Afiliación a Fonosa',
        security: Procedure::AUTHENTICATION,
        type_of_procedure: Procedure::SIMPLE_PROCEDURE,
        active_in_totem: true,
        class_name_simple: 'ProcedureCertificadoAfiliacionFonasa',
        id_proceso_simple: 13,
        id_etapa_simple: 20
      )
  end
end
