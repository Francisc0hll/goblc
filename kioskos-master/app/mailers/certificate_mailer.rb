class CertificateMailer < ApplicationMailer
  def send_pdf(mail, pdf, pdf_name, subject)
    attachments[pdf_name] = {
      mime_type: 'application/pdf',
      content: pdf
    }
    mail(to: mail, subject: subject)
  end
end
