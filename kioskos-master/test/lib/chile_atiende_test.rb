require 'test_helper'

class ChileAtiendeTest < ActionDispatch::IntegrationTest

  test 'gets tramite info for "Permiso de circulación"' do
    permiso_circulacion_tramite_id = 9611
    tramite_response = permiso_circulacion_tramite_info
    # Id of the tramite we received corresponds to the id of the tramite we are
    # looking for => they are the same
    assert_equal tramite_response['ficha']['id'].to_i, permiso_circulacion_tramite_id.to_i
    assert_equal tramite_response['ficha']['titulo'], 'Permiso de circulación'
    # Parse the tramite_response, then verify that there are no tags left
    # afterwards
    filtered_resp = ChileAtiende.filter_chile_atiende_response(tramite_response['ficha'])

    filtered_resp.values do |val|
      assert_equal val['{{'], nil
      assert_equal val['}}'], nil
    end
  end

  test 'gets tramite info for "Seguro accidentes escolares"' do
    seguro_accidentes_escolares_tramite_id = 40068
    tramite_response = seguro_accidentes_escolares_tramite_info

    assert_equal tramite_response['ficha']['id'].to_i, seguro_accidentes_escolares_tramite_id.to_i
    assert_equal tramite_response['ficha']['titulo'], 'Seguro contra accidentes escolares'

    filtered_resp = ChileAtiende.filter_chile_atiende_response(tramite_response['ficha'])
    filtered_resp.values do |val|
      assert_equal val['{{'], nil
      assert_equal val['}}'], nil
    end
  end

  test 'gets tramite info for "Prorroga cotizacion boleta tramite"' do
    prorroga_cotizacion_boleta_tramite_id = 12016
    tramite_response = prorroga_cotizacion_boleta_tramite_info

    assert_equal tramite_response['ficha']['id'].to_i, prorroga_cotizacion_boleta_tramite_id.to_i
    assert_equal tramite_response['ficha']['titulo'], 'Prórroga de la cotización previsional obligatoria para independientes que emiten boletas'

    filtered_resp = ChileAtiende.filter_chile_atiende_response(tramite_response['ficha'])
    filtered_resp.values do |val|
      assert_equal val['{{'], nil
      assert_equal val['}}'], nil
    end

  end
end
