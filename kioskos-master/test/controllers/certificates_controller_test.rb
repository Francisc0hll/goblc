require 'test_helper'

class CertificatesControllerTest < ActionDispatch::IntegrationTest
  setup  do
    cookies['hostname'] = totems(:active).tid
    set_rut('111111111')
  end

  test 'should get index' do
    get certificates_path
    assert_response :success
  end

  test 'should get show' do
    certificate = procedures(:free_anonymous)
    get certificate_path(certificate)
    assert_response :success
  end

  test 'should get create' do
    certificate = procedures(:free_anonymous)
    ENV['SIMPLE_URL'] = 'https://minsegpres.simple.cl/backend/api/ejecutar'
    VCR.use_cassette('simple_get_authenticated_certificate') do
      post create_certificates_path(certificate, email: 'test@test.cl')
    end
    assert_response :success
  end

  test 'should create Constancia de pensionado certificate with pension' do
    certificate = procedures(:constancia_de_pensionado)
    VCR.use_cassette('simple_get_authenticated_certificate_constancia_de_pensionado_with_pension') do
      post create_certificates_path(certificate, email: 'test@test.cl', send_by_email: true)
    end
    assert response.body.include? 'Tu certificado ha sido enviado al correo electrónico'
  end

  test 'should create Constancia de pensionado certificate without pension' do
    certificate = procedures(:constancia_de_pensionado)
    VCR.use_cassette('simple_get_authenticated_certificate_constancia_de_pensionado_without_pension') do
      post create_certificates_path(certificate, email: 'test@test.cl', send_by_email: true)
    end
    assert response.body.include? 'La persona no tiene calidad de pensionado'
  end

  test 'should create Constancia de pensionado certificate without pension information' do
    certificate = procedures(:constancia_de_pensionado)
    VCR.use_cassette('simple_get_authenticated_certificate_constancia_de_pensionado_without_pension_information') do
      post create_certificates_path(certificate, email: 'test@test.cl', send_by_email: true, mes: "1", annio: "2017")
    end

    assert response.body.include? 'No posee Certificado de Liquidacion Pension Mensual'
  end

  test 'should create Certificado de situación militar' do
    certificate = procedures(:certificado_situacion_militar)
    VCR.use_cassette('simple_get_authenticated_certificate_certificado_situacion_militar') do
      post create_certificates_path(certificate, email: 'test@test.cl', send_by_email: true)
    end
    assert response.body.include? 'Tu certificado ha sido enviado al correo electrónico'
  end

  

end
