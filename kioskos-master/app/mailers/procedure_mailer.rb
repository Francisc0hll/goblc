class ProcedureMailer < ApplicationMailer
  def send_info(mail, procedure)
    @procedure = procedure
    mail(to: mail, subject: 'Información solicitada en Kiosko de AutoAtención')
  end
end
