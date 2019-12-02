class ChromeStarter
  def self.restart
    fork do 
    `
    pgrep chrome | xargs kill -9
    rm -rf /home/kiosk/.{config,cache}/google-chrome/

    /usr/bin/google-chrome \
    --no-first-run \
        --disable \
        --disable-translate \
        --disable-infobars \
        --disable-suggestions-service \
        --disable-save-password-bubble \
        --start-maximized \
        --remote-debugging-port=9222 \
        --incognito \
        'https://kioscos.digital.gob.cl/'
    `
    end
    p "Chrome is started!"
  end
end