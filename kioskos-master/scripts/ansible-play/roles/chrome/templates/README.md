autorun chrome kiosk y monitoreo
========================

Pruebas de monitor de Chrome:

Bajar:

 debian 9 netinst [desde la pagina de debian](https://www.debian.org/distrib/netinst.en.html)

crear un usuario llamado `kiosk`

añadirlo a sudoers

`usermod -aG sudo kiosk`



Editar `/etc/apt/sources.list`

 añadiendo:

`deb http://dl.google.com/linux/chrome/deb/ stable main`

Ejecutar:

`wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -`

Ejecutar:

`apt-get update`

`# apt-get install --no-install-recommends  sudo xorg openbox lightdm google-chrome-stable`
`# apt-get install --no-install-recommends  ruby 2.3.0`
`# gem install bundler`

Editar `/etc/lightdm/lightdm.conf` y dejarlo como el lightdm.conf de ejemplo que
se encuentra en esta misma carpeta

Crear `/opt/chrome_monitor` con el contenido del archivo de ejemplo del mismo
nombre

Ejecutar

`# chmod +x /opt/chrome_monitor`


crear o añadir a `/etc/xdg/openbox/autostart`
lo siguiente:

```
xset -dpms
xset s off
/opt/chrome_monitor
```


