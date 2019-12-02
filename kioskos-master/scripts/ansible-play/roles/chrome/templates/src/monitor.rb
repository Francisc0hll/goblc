require 'json'
require 'time'
require_relative 'chrome_starter'
require 'net/http'
require 'uri'
require 'chrome_remote'

TOTEM_APP_ADDRESS = 'https://kioscos.digital.gob.cl/'.freeze

class Monitor
  attr_reader :last_chrome_heartbeat

  def initialize
    @last_chrome_heartbeat = Time.now
  end

  def chrome_down?
    Time.now - @last_chrome_heartbeat >= 10
  end

  def monitoring_loop
    loop do
      sleep 2
      p "looping..."
      # Check if current history entry is the totem's url
      history_info = ChromeRemote.client.send_cmd("Page.getNavigationHistory")
      ChromeRemote.client.send_cmd("Network.setCookie", {url: TOTEM_APP_ADDRESS, name: 'hostname', value: `hostname`.strip})
      p "history info #{history_info}"
      current_index, entries = history_info.fetch_values('currentIndex', 'entries')
      p "entries #{entries}"
      if entries[current_index]['url'][TOTEM_APP_ADDRESS]
        @last_chrome_heartbeat = Time.now
        next
      end
      # Else, just nuke Chrome and start all over again
      ChromeStarter.restart
    end
  end

  def start
    monitoring_loop
  rescue => e
    puts "rescued error =>  #{e}"
    ChromeStarter.restart
    start
  end
end
