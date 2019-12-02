class AddColumnsIdProcesoSimpleAndIdEtapaSimpleAndClassNameSimpleToProcedure < ActiveRecord::Migration[5.0]
  def change
    add_column :procedures, :id_proceso_simple, :integer
    add_column :procedures, :id_etapa_simple, :integer
    add_column :procedures, :class_name_simple, :string
  end
end
