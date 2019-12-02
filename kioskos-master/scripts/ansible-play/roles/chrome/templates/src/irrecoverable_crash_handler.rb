require 'bundler'
Bundler.setup
require 'mail'

class IrrecoverableCrashHandler
  attr_accessor :chrome_crash_announced
  EMAIL_FROM_ADDRESS = 'noreply@example.com'.freeze
  EMAIL_TO_ADDRESS = 'someone@example.com'.freeze

  def initialize
    @chrome_crash_announced = false
  end

  def for_chrome
    # This should send an email or hit an endpoint or whatever else to announce
    # that chrome has failed irrecoverably
    p "Enviando email"
    send_email(EMAIL_FROM_ADDRESS,
               EMAIL_TO_ADDRESS,
               'totem caido',
               'se cayo un totem') unless chrome_crash_announced
    @chrome_crash_announced = true
  end

  def chrome_fixed!
    @chrome_crash_announced = false
  end

  def send_email(from, to, subject, body)
    mail = 
      Mail.new do |m|
        m.from = from
        m.to = to
        m.subject = subject
        m.body = body
        m.delivery_method :sendmail
      end
    mail.deliver!
  end

end