class CreateDeclaracionDeRentaProcedure < ActiveRecord::Migration[5.0]
  def change
    Procedure.create(
        name: 'Certificado de declaración de renta',
        security: Procedure::AUTHENTICATION,
        type_of_procedure: Procedure::SIMPLE_PROCEDURE,
        active_in_totem: true,
        class_name_simple: 'ProcedureDeclaracionDeRenta',
        id_proceso_simple: 11,
        id_etapa_simple: 18
      )
  end
end
