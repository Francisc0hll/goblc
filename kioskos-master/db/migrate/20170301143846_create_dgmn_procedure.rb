class CreateDgmnProcedure < ActiveRecord::Migration[5.0]
  def change
    Procedure.create(
        name: 'Certificado de Situación Militar',
        procedure_id: 1856,
        security: Procedure::AUTHENTICATION,
        type_of_procedure: Procedure::SIMPLE_PROCEDURE
      )
  end
end
