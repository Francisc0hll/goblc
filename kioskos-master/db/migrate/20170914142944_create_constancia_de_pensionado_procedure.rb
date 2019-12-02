class CreateConstanciaDePensionadoProcedure < ActiveRecord::Migration[5.0]
  def change
    Procedure.reset_column_information
    Procedure.create(
        name: 'Certificado de constancia de pensionado',
        procedure_id: 1,
        security: Procedure::AUTHENTICATION,
        type_of_procedure: Procedure::SIMPLE_PROCEDURE,
        active_in_totem: true,
        class_name_simple: 'ProcedureConstanciaDePensionado',
        id_proceso_simple: 5,
        id_etapa_simple: 8
      )
  end
end
