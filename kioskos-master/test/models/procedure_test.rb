require 'test_helper'

class ProcedureTest < ActiveSupport::TestCase
  test 'anonymous procedure' do
    procedure = procedures(:free_anonymous)
    assert_equal true, procedure.anonymous?
  end
end
