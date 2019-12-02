require 'test_helper'

class AdminRolesFeatureTest < Capybara::Rails::TestCase

  def setup
    reset_session!
  end

  test 'Should login as plain admin' do
    admin_sign_in
    page.must_have_content 'Has iniciado sesión satisfactoriamente.'
    page.must_have_content 'admin@example.com'
  end


  test 'Admin should be able to read certificates of his/her institution' do
    admin_sign_in
    find('#logs').hover
    find('a[href="/admin/certificates"]').click
    page.must_have_content 'usuarioejemplo@example.com'
    assert_not page.has_content? 'yetanotherexampleuser@example.com'
    page.must_have_content 'failedemailfreeanon@example.com'
    assert_not page.has_content? 'emailfailedconstancia@example.com'
    assert_equal find_all('a', text: 'Ver').count, 2
    link = first('a', text: 'Ver')
    certificate_id = link[:href].split('/').last.to_i
    certificate = Certificate.find(certificate_id)
    link.click
    page.must_have_content certificate.procedure.name
    page.must_have_content certificate.rut

  end

  test 'Admin should be able to read, update his/her own data only' do
    admin_sign_in
    find('a[href="/admin/admin_users"]').click
    assert_not page.has_content? 'superadmin@example.com'
    page.must_have_content 'admin@example.com'
    assert_equal find_all('a', text: 'Ver').count, 1
    assert_equal find_all('a', text: 'Editar').count, 1
    # cannot delete him/herself
    assert_not page.has_content? 'Eliminar'

    # can view AdminUser details
    link = first('a', text: 'Ver')
    admin_id = link[:href].split('/').last.to_i
    admin = AdminUser.find(admin_id)
    link.click
    page.must_have_content admin.email
    page.must_have_content admin.admin_type
    page.must_have_content admin.institution.name

    page.driver.go_back
    # can edit AdminUser

    link = first('a', text: 'Editar')
    admin_id = link[:href].split('/')[-2]
    admin = AdminUser.find admin_id
    link.click

    assert_equal find('input#admin_user_email')[:value], admin.email
    page.must_have_field 'Password'
    page.must_have_field 'Password confirmation'

    select = find('select#admin_user_institution_id')
    assert_equal select[:value], admin.institution.id.to_s
    assert_equal select.find_all('option').map(&:value), ['', '1']
    assert_equal select.find('option[selected]').text, 'Ministerio del Testeo'


    fill_in 'Email', with: 'someotheremail@thisisatest.com'
    fill_in 'admin_user_password', with: 'password'
    fill_in 'admin_user_password_confirmation', with: 'password'

    click_on 'Actualizar'

    fill_in 'admin_user_email', with: 'someotheremail@thisisatest.com'
    fill_in 'admin_user_password', with: 'password'
    click_on 'Iniciar Sesión'

    page.must_have_content 'someotheremail@thisisatest.com'

    page.driver.go_back # to login
    page.driver.go_back # to edit
    page.driver.go_back # to admin index


  end

  test 'Admin should be able to read, update Totems of his/her institution' do
    admin_sign_in
    find("a[href='/admin/totems']").click # The 'Totems' button
    page.must_have_content 'Ministerio del test'
    assert_not page.has_content? 'Ministerio que no existe'

    assert_equal find_all('a', text: 'Ver').count, 2
    assert_equal find_all('a', text: 'Editar').count, 2
    link = first('a', text: 'Ver')
    totem_id = link[:href].split('/').last
    totem = Totem.find totem_id

    # Totem info is viewable?

    link.click
    page.must_have_content totem.tid
    page.must_have_content totem.rut
    page.must_have_content 'SÍ' if totem.active
    page.must_have_content 'NO' unless totem.active
    page.must_have_content totem.location
    page.must_have_content I18n.t(totem.location_type, scope: 'collections.location_type')

    page.must_have_content totem.institution.name

    page.driver.go_back

    # Totem info is editable?
    link = first('a', text: 'Editar')

    totem_id = link[:href].split('/')[-2] # last item is the action eg: .../{totem_id}/edit
    totem = Totem.find totem_id
    link.click

    assert_equal find('input#totem_tid')[:value], totem.tid
    assert_equal find('input#totem_rut')[:value], totem.rut
    assert_equal find('input#totem_active')[:checked], true if totem.active
    assert_equal find('input#totem_active')[:checked], false unless totem.active
    assert_equal find('input#totem_country_phone_code')[:value], '56'
    assert_equal find('input#totem_location')[:value], totem.location
    assert_equal find('select#totem_location_type')[:value], totem.location_type
    assert_equal find('select#totem_institution_id')[:value], totem.institution_id.to_s

    fill_in 'Ubicación', with: 'Totemlocacion'
    click_on 'Actualizar'
    page.must_have_content 'Totemlocacion'

    page.driver.go_back # back to /edit
    page.driver.go_back # back to totems index

    # Totem should not be deleteable
    assert_not page.has_content? 'Eliminar'
  end

  test 'Admin should be able to read Notifications of his/her institution' do
    admin_sign_in
    find('a[href="/admin/notifications"]').click # The 'Notifications' button
    page.must_have_content 'Tienes un bono esperando por ti'
  end

  test 'Admin should be able to manage authentications of his/her institution' do
    admin_sign_in
    find('#logs').hover
    find('a[href="/admin/authentications"]').click
    page.must_have_content 'Autentificaciones'
    assert_equal find_all('td.col.col-user_id', text: '11111111-9').count, 1
    page.must_have_content '10'

    # authemtication info can be seen

    link = first('a', text: 'Ver')
    auth_id = link[:href].split('/').last
    auth = Authentication.find(auth_id)

    link.click

    page.must_have_content auth.auth_type
    page.must_have_content auth.user.rut
    page.must_have_content auth.minucia
    page.must_have_content auth.finger
    page.must_have_content auth.signature
  end

  test 'Admin shoud be able to read ClaveUnicaPetitions of his/her institution' do
    admin_sign_in

    find('#logs').hover
    find('a[href="/admin/clave_unica_petitions"]').click
    page.must_have_content 'Peticiones Clave Única'

    page.must_have_content '555333999'  # phone no.
    assert_not page.has_content? '222333777' # phone no.
    page.must_have_content 'somefakeemail@example.com'
    assert_not page.has_content? 'anotheremail@example.com'
    page.must_have_content 'success'
    assert_not page.has_content? 'failure'
    assert_equal find_all('a', text: 'Ver').count, 1

    link = first('a', text: 'Ver')
    petition_id = link[:href].split('/').last
    petition = ClaveUnicaPetition.find(petition_id)

    link.click
    page.must_have_content petition.rut
    page.must_have_content petition.totem.tid
    page.must_have_content petition.email
    page.must_have_content petition.phone
  end

  test 'Admin should be able to read ProcedureLogs of his/her institution' do
    admin_sign_in
    find('#logs').hover
    find('a[href="/admin/procedure_logs"]').click

    page.must_have_content 'Consulta de Trámites'
    # totem id
    assert_equal page.find_all('td.col.col-totem_id', text: '10').size, 1
    # Must have no totem with id '13'
    assert_equal page.find_all('td.col.col-totem_id', text: '13').size, 0
    # procedure name
    page.must_have_content 'Obtencion de certificado de generacion de tramites'
    assert_not page.has_content? 'Obtencion de visa'
    # phone
    page.must_have_content '12345'
    assert_not page.has_content? '54321'

    assert_not page.has_content? 'Editar'
    assert_not page.has_content? 'Eliminar'

    link = first('a', text: 'Ver')
    procedure_log_id = link[:href].split('/').last

    procedure_log = ProcedureLog.find(procedure_log_id)

    page.must_have_content procedure_log.totem.tid
    page.must_have_content procedure_log.name
    page.must_have_content procedure_log.chileatiende_id

  end

  test 'Admin should be able to create, read, update, delete Procedures of his/her institution' do
    admin_sign_in
    find("a[href='/admin/procedures']").click # The 'Tramites' button
    page.must_have_content 'Certificado Anónimo'
    page.must_have_content 'Certificado de nota sexto de humanidades'
    page.must_have_content 'Certificado de Identidad'
    assert_not page.has_content? 'Certificado de constancia de pensionado'
    assert_not page.has_content? 'Certificado de situacion militar'

    link = first('a', text: 'Ver')
    procedure_id = link[:href].split('/').last
    procedure = Procedure.find(procedure_id)

    link.click
    page.must_have_content procedure.id
    page.must_have_content procedure.name
    page.must_have_content procedure.price
    page.must_have_content 'SÍ' if procedure.active_in_totem
    page.must_have_content 'NO' unless procedure.active_in_totem
    page.must_have_content procedure.security
    page.must_have_content procedure.institution.name
    page.must_have_content procedure.id_proceso_simple
    page.must_have_content procedure.id_etapa_simple
    page.must_have_content procedure.class_name_simple
    page.must_have_content procedure.chile_atiende_id
    page.must_have_content procedure.category
    page.must_have_content procedure.subcategory

    page.driver.go_back

    link = first('a', text: 'Editar')
    procedure_id = link[:href].split('/')[-2]
    procedure = Procedure.find(procedure_id)

    link.click

    assert_equal find('input#procedure_name')[:value], procedure.name
    assert_equal find('input#procedure_price')[:value].to_i, procedure.price.to_i
    assert_equal find('input#procedure_active_in_totem')[:checked], true if procedure.active_in_totem
    assert_equal find('select#procedure_security')[:value], procedure.security
    assert_equal find('select#procedure_type_of_procedure')[:value], procedure.type_of_procedure
    assert_equal find('textarea#procedure_description')[:value], procedure.description.to_s
    assert_equal find('input#procedure_info')[:value], procedure.info.to_s
    assert_equal find('input#procedure_warning')[:value], procedure.warning.to_s
    assert_equal find('input#procedure_id_proceso_simple')[:value], procedure.id_proceso_simple.to_s
    assert_equal find('input#procedure_id_etapa_simple')[:value], procedure.id_etapa_simple.to_s
    assert_equal find('input#procedure_class_name_simple')[:value], procedure.class_name_simple.to_s
    assert_equal find('input#procedure_chile_atiende_id')[:value], procedure.chile_atiende_id.to_s
    assert_equal find('select#procedure_institution_id')[:value], procedure.institution_id.to_s
    assert_equal find('input#procedure_category')[:value], procedure.category.to_s
    assert_equal find('input#procedure_subcategory')[:value], procedure.subcategory.to_s

    fill_in 'Descripción', with: 'una nueva descripción de testeo'

    click_on 'Actualizar'
    page.must_have_content 'una nueva descripción de testeo'

    page.driver.go_back # to /edit
    page.driver.go_back # to procedures

    assert_difference 'Procedure.count', -1 do
      link = first('a', text: 'Eliminar')
      link.click
    end

  end

  test 'Admin should be able to read SearchProcedureLogs of his/her institution' do
    admin_sign_in
    find('#logs').hover
    find('a[href="/admin/search_procedure_logs"]').click
    page.must_have_content 'Búsquedas de Trámites'
    assert_equal find_all('a', text: 'Ver').count, 2

    page.must_have_content 'militar'
    page.must_have_content 'Llamados al Servicio Militar 2017, Servicio Militar como voluntario'

    page.must_have_content 'notfound'

    assert_not page.has_content? 'salud'
    assert_not page.has_content? 'alsonotfound'
    assert_not page.has_content? 'Seguro de Salud, Compra Bono FONASA'

    link = first('a', text: 'Ver')
    search_procedure_log_id = link[:href].split('/').last
    search_procedure_log = SearchProcedureLog.find search_procedure_log_id
    link.click
    page.must_have_content search_procedure_log.search
    page.must_have_content search_procedure_log.totem.tid
    page.must_have_content 'SÍ' if search_procedure_log.found
    page.must_have_content search_procedure_log.results
  end

  test 'Admin should be able to read, update his/her Institutions' do
    admin_sign_in
    find('a[href="/admin/institutions"]').click
    page.must_have_content 'Ministerio del Testeo'
    assert_not page.has_content? 'Ministerio que no existe'

    # Viewable
    link = first('a', text: 'Ver')
    institution_id = link[:href].split('/').last
    institution = Institution.find institution_id

    link.click

    page.must_have_content institution.name

    page.driver.go_back

    # Editable
    link = first('a', text: 'Editar')
    institution_id = link[:href].split('/')[-2]
    institution = Institution.find institution_id

    link.click
    page.must_have_field 'Nombre'
    page.must_have_content institution.name.upcase
    fill_in 'Nombre', with: 'Ministerio modificado'

    click_on 'Actualizar'

    page.must_have_content 'Ministerio modificado'

    page.driver.go_back # To /edit
    page.driver.go_back # To institutions index

    # Institution shouldn't be deleteable
    assert_not page.has_content? 'Eliminar'
  end

end
