
require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  test 'Test get procedure' do
    VCR.use_cassette('chile_atiende_get_procedure') do
      assert_equal 'Presentación de demanda por despido injustificado', ChileAtiende.get_procedure(327)['titulo']
    end
  end
end
