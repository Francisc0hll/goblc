class Api::V1::AuthenticationController < Api::V1::BaseController
  include ClaveUnicaHelper

    skip_before_action :verify_authenticity_token

    swagger_controller :authentication, 'Totem Authentication token manager'

    swagger_api :create do
      summary "Create or update the totem monitoring register"
      notes "A new register is create if there is no record for that totem_tid"
      response :ok, "Success", :AuthToken
      response :unauthorized
      response :unprocessable_entity
      param :form, :client_id, :string, :required, "The oauth client_id"
      param :form, :client_secret, :string, :required, "The oauth client_secret"
    end

    swagger_model :AuthToken do
      description "A Oauth access token"
      property :token, :string, :required, "access token"
    end

    def create
      response.set_header('Access-Control-Allow-Origin', '*')
      auth_response = api_oauth_token(auth_params[:client_id], auth_params[:client_secret])
      user_token = auth_response['access_token']
      new_auth = ApiAuthentication.new(token: user_token, expires_in: auth_response['expires_in'], token_type: auth_response['token_type'])
      if !new_auth.save
        render json: { errors: "Error" }, status: :unprocessable_entity
      else
        resp = { token: new_auth.token }
        render json: resp, status: :ok
      end
    end

    private
    def auth_params
      params.permit(:client_id, :client_secret)
    end
  end
