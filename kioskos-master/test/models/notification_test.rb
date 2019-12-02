require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  test "don't let save notifications without rut" do
    notification = notifications(:bono)
    notification.rut = nil
    assert_equal false, notification.save
  end

  test "don't let save notifications without message" do
    notification = notifications(:bono)
    notification.message = nil
    assert_equal false, notification.save
  end
end
