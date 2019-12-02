class ChangeAporteFamiliarPermanenteProcedureType < ActiveRecord::Migration[5.0]
  def change
    Procedure.find_by(
      name: 'Consulta de Beneficio de Aporte Familiar Permanente',
      security: Procedure::AUTHENTICATION,
      type_of_procedure: Procedure::SIMPLE_PROCEDURE,
      active_in_totem: true,
      class_name_simple: 'ProcedureAporteFamiliarPermanente',
      id_proceso_simple: 10,
      id_etapa_simple: 17
    ).update!(type_of_procedure: Procedure::COMPLEX_PROCEDURE)
  end
end
