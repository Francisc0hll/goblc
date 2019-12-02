require 'test_helper'

class HomeFeatureTest < Capybara::Rails::TestCase

  setup do
    reset_session!
  end

  test 'Should successfully init the totem' do
    Capybara.current_session.driver.set_cookie('hostname', totems(:active).tid)
    visit totem_path
    assert_equal '/totem', current_path
  end

  test 'Should unsuccessfully init to the totem' do
    visit totem_path
    page.must_have_content 'Activación del Totem Este módulo no pudo ser iniciado. Regulariza esta situación con el administrador Reintentar'
  end

  test 'Should unsuccessfully init to the totem with hostname' do
    Capybara.current_session.driver.set_cookie('hostname', "asd")
    visit totem_path
    page.must_have_content 'Activación del Totem Kiosco asd no configurado en administración. Favor configúrelo en la administración Reintentar'
  end


end
