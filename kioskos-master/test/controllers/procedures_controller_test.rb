require 'test_helper'

class ProceduresControllerTest < ActionDispatch::IntegrationTest
  def setup
    cookies['hostname'] = totems(:active).tid
  end

  test 'should show index' do
    get procedures_path
    assert_template :index
  end

  test 'should show the search template' do
    assert_difference 'SearchProcedureLog.count', 1 do
      VCR.use_cassette('search_permiso_circulacion') do
        post search_procedures_path, params: { search: 'permiso de circulacion',
                                               next_token: nil }
        assert response.body.include? "Permiso de circulaci\u00F3n"
        assert_template 'procedures/search.js.erb'
      end
    end
  end

  test 'should show the "show" template and create a new ProcedureLog' do
    assert_difference 'ProcedureLog.count', 1 do
      VCR.use_cassette('permiso_circulacion_tramite_info') do
        permiso_circulacion_tramite_id = 9611
        get procedure_path(permiso_circulacion_tramite_id)
        assert response.body.include? "permiso\ de\ circulaci\u00F3n"
        assert_template :show
      end
    end
  end

  test 'should show the "show" template, notify the user that the procedure can
  be done in the totem, and create a new ProcedureLog' do
    assert_difference 'ProcedureLog.count', 1 do
      VCR.use_cassette('situacion_militar_info') do
        situacion_militar_tramite_id = 946
        get procedure_path(situacion_militar_tramite_id)
        assert response.body.include? 'militar'
        assert response.body.downcase.include? 'trámite puede realizarse en este tótem'
        assert_template :show
      end
    end
  end

  test 'should show the send info template & queue an email for delivery' do
    permiso_circulacion_tramite_id = 9611
    assert_difference 'ActionMailer::Base.deliveries.count', 1 do
      VCR.use_cassette('permiso_circulacion_tramite_info') do
        post send_info_procedures_path, params: { id: permiso_circulacion_tramite_id,
                                                  email: 'phonymcfakester@example.com' }
        assert_template 'procedures/send_info.js.erb'
      end
    end
  end
end
