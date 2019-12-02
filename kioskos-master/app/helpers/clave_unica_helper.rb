module ClaveUnicaHelper
  include RutHelper

  OAUTH_URL = 'https://apis.digital.gob.cl/totem/oauth2/token'.freeze
  CLAVE_UNICA_LOGIN_URL = 'https://login.claveunica.gob.cl/api/totem/accounts/login'.freeze
  USER_NAME_LASTNAME_URL = 'https://login.claveunica.gob.cl/api/totem/accounts/info'.freeze

  def validate_user(run, password, totem = nil)
    run.delete!('-')
    oauth_token = oauth_token(ENV['CLAVE_UNICA_CLIENT_ID'],
                              ENV['CLAVE_UNICA_CLIENT_SECRET'])
    user_token = validate_user_identity(run, password, oauth_token)
    # Maybe there is a more appropiate exception? RuntimeError feels too generic
    raise 'Usuario o contraseña inválidos' if user_token.nil?
    user_data = get_user_data(user_token, oauth_token)
    raise 'No se pudieron obtener datos del usuario' if user_data.nil?
    authenticate_user_on_totem(user_data, totem)
    'OK'
    rescue Faraday::Error::ConnectionFailed, Faraday::TimeoutError => e
      'TimeOut'
  end

  def oauth_token(client_id, client_secret)
    body = {
      client_id: client_id, client_secret: client_secret, scope: 'validation',
      grant_type: 'client_credentials'
    }
    conn = Faraday.new(url: OAUTH_URL)

    response =
      conn.post do |req|
        req.body = body.to_json
        req.headers['Content-Type'] = 'application/json'
      end
    JSON.parse(response.body)['access_token']
  end

  def api_oauth_token(client_id, client_secret)
    body = {
      client_id: client_id, client_secret: client_secret, scope: 'validation',
      grant_type: 'client_credentials'
    }
    conn = Faraday.new(url: OAUTH_URL)
    response =
      conn.post do |req|
        req.body = body.to_json
        req.headers['Content-Type'] = 'application/json'
      end
    JSON.parse(response.body)
  end

  def validate_api_auth(token)
    token_parts = token.split(' ')
    return false if token_parts.nil? || token_parts.size != 2
    auth = ApiAuthentication.find_by_token(token_parts[1])
    return false if auth.nil?
    return auth.is_valid?(token_parts[0])

  end

  def validate_user_identity(rut, password, oauth2_token)
    rut_with_dots_and_dashes = add_dots_and_dashes(rut)
    # "Rut" should include dots and dash
    body = { username: rut_with_dots_and_dashes, password: Base64.encode64(password) }
    conn = Faraday.new(url: CLAVE_UNICA_LOGIN_URL)
    response =
      conn.post do |req|
        req.body = body.to_json
        req.headers['Authorization'] = 'Bearer ' + oauth2_token
      end
    # response is {"token": "value1235125"}
    JSON.parse(response.body)['token']
  end

  def get_user_data(user_token, oauth_token)
    conn = Faraday.new(url: USER_NAME_LASTNAME_URL)
    response =
      conn.get do |req|
        req.headers['Content-Type'] = 'application/json'
        req.headers['Authorization'] = 'Bearer ' + oauth_token
        req.headers['token'] = user_token
      end
    JSON.parse(response.body)
  end

  def get_rut_from_user_data(user_data)
    numero = user_data['object']['RolUnico']['numero'].to_s
    digito_verificador = user_data['object']['RolUnico']['DV'].to_s
    numero << digito_verificador
  end

  def authenticate_user_on_totem(user_data, totem)
    rut = get_rut_from_user_data(user_data)
    email = user_data['object']['other_info']['email']
    names = user_data['object']['name']['nombres'].join(' ')
    apellido_paterno, apellido_materno = user_data['object']['name']['apellidos']
    user = User.find_by(rut: rut)
    if user.present?
      user.update(email: email, name: names,
                  last_name_father: apellido_paterno,
                  last_name_mother: apellido_materno)
    else
      user = User.new(rut: rut, email: email, name: names,
                      last_name_father: apellido_paterno,
                      last_name_mother: apellido_materno)
    end
    user.assign_totem(totem || current_totem)
    user.save!
    Authentication.create!(user_id: user.id, auth_type: auth_type(totem),
                           totem: (totem || current_totem))
    session[:user_id] = user.id
    session[:rut] = user.rut
  end

  def auth_type(totem=nil)
    totem.nil? ? 'clave_unica' : 'inicio_sesion'
  end
end
