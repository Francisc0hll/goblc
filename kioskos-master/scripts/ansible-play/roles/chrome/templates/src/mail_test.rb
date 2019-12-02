require 'bundler'
Bundler.setup

require 'mail'

class Mailer
  # Para configurar mail 
  # https://easyengine.io/tutorials/linux/ubuntu-postfix-gmail-smtp/
  attr_reader :mail

  def initialize
    @mail = 
      Mail.new do |m|
        m.from = "ejemplofrom@example.com"
        m.to = "emaildestino@ejemplo.cl"
        m.subject = "hola mundo"
        m.body = "soy un body"
        m.delivery_method :sendmail
      end
  end
  def send!
    @mail.deliver!
  end

end


Mailer.new.send!