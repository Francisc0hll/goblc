require 'test_helper'

class NotificationFeatureTest < Capybara::Rails::TestCase
  setup do
    Capybara.current_session.driver.set_cookie('hostname', totems(:active).tid)
  end

  #TODO: descomentar cuando se implemente el modulo de beneficios
  # test 'Notifications for RUT' do
  #   visit notifications_path
  #   fill_in_onscreen_keyboard with: RUT_DUMMY
  #   click_on('Continuar')
  #   within '.name-btn' do
  #     notifications(:bono).message
  #   end
  # end
end
