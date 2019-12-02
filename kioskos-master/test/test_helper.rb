ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/rails/capybara'
require 'capybara/poltergeist'
require 'minitest/reporters'

Minitest::Reporters.use!

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app,
                                    window_size: [1080, 2520],
                                    screen_size: [1080, 2520],
                                    js_errors: true)
end
Capybara.register_driver :poltergeist do |app|
  options = {
    window_size: [1080, 2520],
    phantomjs_options: ['--ignore-ssl-errors=yes', '--ssl-protocol=any'],
    timeout: 120
  }
  Capybara::Poltergeist::Driver.new(app, options)
end
Capybara.javascript_driver = :poltergeist
Capybara.default_driver = :poltergeist

require 'capybara-screenshot/minitest'

require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'test/vcr_cassettes'
  config.hook_into :webmock # or :fakeweb
  config.ignore_localhost = true
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  self.use_transactional_tests = false
end



class ActionDispatch::IntegrationTest

  def permiso_circulacion_tramite_info
    VCR.use_cassette('permiso_circulacion_tramite_info') do
      # This number is arbitrary, as it's simply the id of the tramite
      # on ChileAtiende
      id = 9611
      conn = Faraday.new(url: ChileAtiende::BASE_URL)
      resp = conn.get "/api/fichas/#{id}", access_token: ChileAtiende::TOKEN, type: 'JSON'
      JSON.parse(resp.body)
    end
  end

  def search_permiso_circulacion
    VCR.use_cassette('search_permiso_circulacion') do
      search_term = 'permiso de circulación'
      next_step = nil
      max_results = 6
      conn = Faraday.new(url: BASE_URL)
      resp = conn.get '/api/fichas', access_token: ChileAtiende::TOKEN,
                                     type: 'JSON',
                                     maxResults: max_results,
                                     pageToken: next_step,
                                     query: search_term
      JSON.parse(resp.body)
    end
  end

  def seguro_accidentes_escolares_tramite_info
    VCR.use_cassette('seguro_accidentes_escolares_tramite_info') do
      # This number is arbitrary, as it's simply the id of the tramite
      # on ChileAtiende
      id = 40_068
      conn = Faraday.new(url: ChileAtiende::BASE_URL)
      resp = conn.get "/api/fichas/#{id}", access_token: ChileAtiende::TOKEN, type: 'JSON'
      JSON.parse(resp.body)
    end
  end

  def prorroga_cotizacion_boleta_tramite_info
    VCR.use_cassette('prorroga_cotizacion_boleta_tramite_info') do
      # This number is arbitrary, as it's simply the id of the tramite
      # on ChileAtiende
      id = 12_016
      conn = Faraday.new(url: ChileAtiende::BASE_URL)
      resp = conn.get "/api/fichas/#{id}", access_token: ChileAtiende::TOKEN, type: 'JSON'
      JSON.parse(resp.body)
    end
  end

  def set_rut(rut)
    post create_session_certificates_path, params: { id: rut }
  end

end

class Capybara::Rails::TestCase

  def fill_in_onscreen_keyboard(opts = {})
    raise ArgumentError, 'Must include :with => (string)' unless opts[:with]
    not_found_chars = []
    opts[:target]&.click
    opts[:with].chars.each { |char| press_char_on_keyboard(char, not_found_chars) }
    puts "\n couldn't find some characters => #{not_found_chars.join(', ')} \n"
    opts[:with] # for debugging purposes, return the given string
  end

  def press_char_on_keyboard(char, not_found_chars)
    sleep 0.2 # Otherwise you get one char only!
    find("button[data-value=\"#{char}\"]").click
  rescue Capybara::ElementNotFound
    not_found_chars << "\"#{char}\""
  end

  def superadmin_sign_in
    reset_session!
    VCR.use_cassette('superadmin_sign_in') do
      visit admin_root_path
      fill_in 'admin_user[email]', with: 'superadmin@example.com'
      fill_in 'admin_user[password]', with: 'password'
      find('input[type=submit][name=commit]').click
    end
  end

  def admin_sign_in
    reset_session!
    VCR.use_cassette('superadmin_sign_in') do
      visit admin_root_path
      fill_in 'admin_user[email]', with: 'admin@example.com'
      fill_in 'admin_user[password]', with: 'password'
      find('input[type="submit"][name="commit"]').click
    end
  end


end
