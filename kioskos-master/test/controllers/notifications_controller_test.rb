require 'test_helper'

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    cookies['hostname'] = totems(:active).tid
    notification = notifications(:bono)
    get notification_path(notification.rut)
    assert_includes @response.body, notification.message
  end
end
