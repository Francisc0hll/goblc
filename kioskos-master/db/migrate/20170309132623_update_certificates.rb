class UpdateCertificates < ActiveRecord::Migration[5.0]
  def change
    Procedure.where(procedure_id: nil).delete_all
    certificate = Procedure.find_by(procedure_id: 1856)
    certificate.active_in_totem = true
    certificate.info = "El trámite se puede realizar durante todo el año."
    certificate.description = "Permite acreditar que la situación militar del interesado está en conformidad con la ley.<br /><br />

En Chile, el certificado se puede solicitar en línea o en las oficinas del cantón de reclutamiento; en el extranjero, en cualquier consulado chileno.<br /><br />

Si no tiene la situación militar al día diríjase al cantón de reclutamiento más cercano."
    certificate.save
  end
end
