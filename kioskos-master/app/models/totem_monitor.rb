class TotemMonitor < ApplicationRecord

  validates :totem_tid, :ping_time, presence: true

  def totem_is_down?
    interval = (ENV['MONITORING_INTERVAL'] || 60000).to_i
    difference = (Time.now - ping_time).to_i * 1000
    difference > interval
  end

end