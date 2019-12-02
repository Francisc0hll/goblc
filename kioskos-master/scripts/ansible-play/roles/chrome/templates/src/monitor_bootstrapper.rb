require 'bundler'
Bundler.setup

require_relative 'monitor'
require_relative 'chrome_starter'
require_relative 'irrecoverable_crash_handler'
require 'eventmachine'

class MonitorBootstrapper

  class << self

    def bootstrap
      monitor = Monitor.new
      crash_handler = IrrecoverableCrashHandler.new
      Thread.new { interval_timer(monitor, crash_handler) }
      ChromeStarter.restart
      sleep 5
      monitor.start
    end

    def interval_timer(monitor, crash_handler)
      puts "New thread here"
      puts "Monitor => #{monitor}"
      EventMachine.run do
        EventMachine::PeriodicTimer.new(5) do
          p "checking if chrome_down?..."
          next crash_handler.for_chrome if monitor.chrome_down?
          crash_handler.chrome_fixed! unless crash_handler.chrome_crash_announced
        end
      end
    end

  end

end

MonitorBootstrapper.bootstrap







