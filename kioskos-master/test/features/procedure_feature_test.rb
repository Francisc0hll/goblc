require 'test_helper'

class ProcedureFeatureTest < Capybara::Rails::TestCase
  # def teardown
  #   super
  #   Capybara.use_default_driver
  # end

  setup do
    @mail = 'test@test.com'
    Capybara.current_session.driver.set_cookie('hostname', totems(:active).tid)
    ENV['SIMPLE_URL'] = 'https://minsegpres.simple.cl/backend/api/ejecutar'
  end

  test 'get some Procedure\'s info' do
    VCR.use_cassette('get_procedures_index') do
      visit procedures_path
      VCR.use_cassette('get_sistema_seguridad_privada_info') do
        click_on('Sistema de Seguridad Privada: Requisitos para un servicio de Guardias de Seguridad')
        page.must_have_content('Descripción:')
      end
    end
  end

  test 'get some Procedure\'s info that can be done on the totem' do
    visit procedures_path
    search_input = find('input[name="search"]')
    # The reverse is because this input in particular gets entered backwards
    #  for reasons unknown
    fill_in_onscreen_keyboard target: search_input, with: ' militar '.reverse
    click_on 'Buscar'
    VCR.use_cassette('search_certificados_with_militar') do
      page.must_have_content 'Certificado de situación militar al día'
      input = find('a.name-btn[href="\/procedures\/946"]')
      VCR.use_cassette('search_situacion_militar_info') do
        input.click
        page.must_have_content 'Este trámite puede realizarse en este tótem'
      end
    end
  end
end
