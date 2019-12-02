require 'test_helper'

class CertificateFeatureTest < Capybara::Rails::TestCase

  def use_hrefs_as_if_match_on_card_working
    # The other option I see is somehow mocking the whole MOC server, which
    # would be even hackier
    page.execute_script(
      <<~JAVASCRIPT
        [].slice.call(document.querySelectorAll('a.name-btn')).forEach(function(btn) {
          btn.href = btn.href.split("?")[0];
        })
      JAVASCRIPT
    )
  end

  setup do
    @mail = 'test@test.com'
    Capybara.current_session.driver.set_cookie('hostname', totems(:active).tid)

    ENV['SIMPLE_URL'] = 'https://minsegpres.simple.cl/backend/api/ejecutar'
  end

  test 'Anonymous certificate path with MOC working' do
    visit certificates_path
    within '.certificates .row' do
      use_hrefs_as_if_match_on_card_working
      click_on(procedures(:free_anonymous).name)
    end
    email_elem = find('input[name="email"]')
    fill_in_onscreen_keyboard target: email_elem, with: @mail
    VCR.use_cassette('simple_get_anonymous_certificate') do
      click_on('Enviar certificado')
    end
    within '.success' do
      'Certificado enviado exitosamente'
    end
  end

  test 'Insufficent certificate path with MOC working' do
    visit certificates_path
    within '.certificates .row' do
      use_hrefs_as_if_match_on_card_working
      click_on(procedures(:bad_certificate).name)
    end
    email_elem = find('input[name="email"]')
    fill_in_onscreen_keyboard target: email_elem, with: @mail
    VCR.use_cassette('simple_get_bad_certificate') do
      click_on('Enviar certificado')
    end
    within '.error' do
      'Certificado no pudo ser procesado'
    end
  end

  test 'Authenticated certificate path with MOC working' do
    visit certificates_path
    within '.certificates .row' do
      use_hrefs_as_if_match_on_card_working
      click_on(procedures(:authenticated_certificate).name)
    end
    page.must_have_content 'A continuación necesitamos validar tu identidad. Para ello te indicaremos primero donde deberás poner tu cédula y seguido, la huella de tu dedo índice.'
    assert_equal '/certificates/intro_identity_validation', current_path
  end

  test 'Anonymous certificate path without MOC working' do
    visit certificates_path
    within '.certificates .row' do
      click_on(procedures(:free_anonymous).name)
    end
    email_elem = find('input[name="email"]')
    fill_in_onscreen_keyboard target: email_elem, with: @mail
    VCR.use_cassette('simple_get_anonymous_certificate') do
      click_on('Enviar certificado')
    end
    within '.success' do
      'Certificado enviado exitosamente'
    end
  end

  test 'Insufficent certificate path without MOC working' do
    visit certificates_path
    within '.certificates .row' do
      click_on(procedures(:bad_certificate).name)
    end
    email_elem = find('input[name="email"]')
    fill_in_onscreen_keyboard target: email_elem, with: @mail
    VCR.use_cassette('simple_get_bad_certificate') do
      click_on('Enviar certificado')
    end
    within '.error' do
      'Certificado no pudo ser procesado'
    end
  end

  test 'Authenticated certificate path without MOC working' do
    visit certificates_path
    within '.certificates .row' do
      click_on(procedures(:authenticated_certificate).name)
    end
    # The window location takes a bit to change, because turbolinks
    sleep 3
    assert_equal authenticate_clave_unicas_path, current_path
  end
end
