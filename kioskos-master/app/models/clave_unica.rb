class ClaveUnica
  TOKEN = ENV['GET_CLAVEUNICA_TOKEN']
  BASE_URL = ENV['GET_CLAVEUNICA_URL']

  def self.create(user, phone_code, args)
    conn = Faraday.new(url: BASE_URL)
    nombreCompleto = user.name.gsub(/[;]/, ' ')
    nombreMinus=nombreCompleto.mb_chars.downcase.to_s
    nombreCapitalizado=nombreMinus.titleize
    nombreArreglo=nombreCapitalizado.split(' ')
    body = {
      RUN: {
        numero: user.rut_base.to_i,
        DV: user.rut_dv.to_s,
        tipo: 'RUN'
      },
      name: {
        nombres: nombreArreglo[0..-3],
        apellidos: nombreArreglo[-2..-1]
      },
      email: args[:mail],
      phone: {
        code: "+#{phone_code.to_s.delete('+')}",
        number: args[:phone].to_i   
      },
      token: TOKEN.to_s,
      method: args[:create_method]
    }
    if args[:create_method] == "screen"
      body[:password] = args[:password]
    end
    Rails.logger.debug("debug::" + body.to_s)
    response = conn.post do |req|
      req.body = body.to_json
      req.headers['cache-control'] = 'no-cache'
      req.headers['Content-Type'] = 'application/json'
    end  
  rescue => e
    Rollbar.error(e)
    false
  end
end
