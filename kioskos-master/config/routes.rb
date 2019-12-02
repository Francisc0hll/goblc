Rails.application.routes.draw do

  resources :certificates, only: [:index, :show] do
    collection do
      post 'create_session', to: 'certificates#create_session', as: :create_session
      get 'field_examples', to: 'certificates#field_examples', as: 'field_examples'
      post 'create/:id', to: 'certificates#create', as: 'create'
      get 'intro_identity_validation', to: 'certificates#intro_identity_validation'
      get '/biometric_validation', to: 'certificates#biometric_validation'
      get '/biometric_validation_step_two', to: 'certificates#biometric_validation_step_two'
      get 'rut', to: 'certificates#rut', as: :rut
      post '/create_complex', to: 'certificates#create_complex'
    end
  end

  resources :notifications
  resources :procedures do
    collection do
      post :search
      post :send_info
    end
  end

  resources :institutions

  get '/totem' => 'totems#index'
  post '/login' => 'home#create'
  get '/logout' => 'home#destroy'

  devise_for :users
  devise_scope :user do
    get 'sign_in', to: 'devise/sessions#new', :as => :new_user_session
    delete 'sign_out', to: 'devise/sessions#destroy', :as => :destroy_user_session
  end

  resources :clave_unicas, only: [:new, :create] do
    collection do
      get 'authenticate'
      post 'validate'
      get 'cellphone'
      get 'email'
      get 'error'
      get 'screen'
      post 'screen_step2'
      get 'success'
      get 'alternatives'
    end
  end
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"

  scope 'biometrics' do
    get 'index', to: 'biometrics#index', as: :biometrics_index
    get 'intro', to: 'biometrics#intro', as: :biometrics_intro
    get 'step_two', to: 'biometrics#step_two', as: :biometrics_step_two
    get 'validate_result', to: 'biometrics#validate_result', as: :biometrics_validate_result
    post 'register_event', to: 'biometrics#register_event'
  end

  namespace :api do
    namespace :v1 do
      resources :totem_monitors, only: [:create, :index]
      resources :procedure_monitors, only: [:index]
      resources :authentication, controller: 'authentication', only: [:create]
    end
  end

  get '/api' => redirect('/swagger/dist/index.html?url=/apidocs/api-docs.json')
end
