
require 'test_helper'

class ClaveUnicaHelperTest < ActiveSupport::TestCase
  include ClaveUnicaHelper

  test 'correctly dashes and dots ruts' do
    rut1 = '71234567'
    rut2 = '182567779'

    dotted_dashed_rut1 = add_dots_and_dashes(rut1)
    dotted_dashed_rut2 = add_dots_and_dashes(rut2)

    assert_equal dotted_dashed_rut1, '7.123.456-7'
    assert_equal dotted_dashed_rut2, '18.256.777-9'
  end

end
