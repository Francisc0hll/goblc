# Plataforma de Kioscos de AutoAtención

## Configuración/Instalación en Desarrollo

### Requisitos Previos

- Docker
- Make
- Un plugin de editorconfig en tu editor de texto

### Instalación y Ejecución

Nota: Solo probado en MacOSX y Linux.

Asumiendo que se cuenta con una instalación funcional de Docker, solo se necesita configurar credenciales para dependencias con servicios de terceras partes. Todas estas credenciales se configuran mediante variables de entorno.

Por ejemplo, para poder conectarse a ClaveUnica:

    export CHILEATIENDE_TOKEN=our-chile-atiende-secret

Luego que esas credenciales están asignadas, sólo se necesita ejecutar:

    $ make

Y esperar unos minutos, porque tomará tiempo que docker se descargue las imágenes base de las dependencias del proyecto (a menos que ya hayan sido descargadas previamente).

Lo que ocurre durante este tiempo se puede resumir como:

1. Construir las imágenes docker para los containers de esta aplicación, descargando contenedores estándar de los que dependen

2. Crear la base de datos PostgreSQL (dentro del contenedor correspondiente) y ejecutar las migraciones de Rails.

3. Ejecutar todos los contenedores.

Cuando se hacen cambios en las dependencias de la aplicación Rails, o en los contenedores Docker o en migraciones de base de datos, basta volver a ejecutar `make` para actualizar dependencias y base de datos y recargar la aplicación web. **Nota**: No olvidar mantener en variables de entorno las credenciales mencionadas previamente.

#### Resolución de problemas

En caso que la aplicación no se ejecute, revisar los logs en `log/development.log` y/o ejecutar `docker-compose logs` para detectar el problema.

## Instalación en Producción

En producción se debe ejecutar la última imagen `egob/plataforma-kioscos-autoatencion` desde DockerHub. Esta imagen es construida desde la rama master de este repositorio como parte del proceso de integración continua (mediante `make production-build` y etiquetado posterior). La imagen entrega una aplicación web auto-contenida y stateless (facilitando su escalabilidad horizontal) que solo necesita las siguientes variables de entorno para correr:

- `SECRET_KEY_BASE`: Un string aleatorio que puede ser generado mediante el comando `docker-compose run web rails secret`. El valor debe ser igual para todas las instancias ejecutandose en producción.

- `DATABASE_URL`: Una URL que apunta a la base de datos PostgreSQL (ej: `postgres://myuser:mypass@localhost/somedatabase`).

- `CHILEATIENDE_TOKEN`: Token de API ChileAtiende

- `GET_CLAVEUNICA_TOKEN`: Token de API de generación de Clave Única

- `GET_CLAVEUNICA_URL`: URL de API de generación de Clave Única

- `SIMPLE_URL`: URL de API de certificados de S.I.M.P.L.E

- `MOC_SECRET`: Secreto de seguridad compartida con la app de MatchOnCard

- `SMTP_ADDRESS`: SMTP server address.

- `SMTP_PORT`: SMTP server port.

- `SMTP_DOMAIN`: SMTP server domain.

- `SMTP_USER`: SMTP server user name.

- `SMTP_SECRET`: SMTP server password.

- `SMTP_FROM_EMAIL`: SMTP from what email send the mails

- `ROLLBAR_ACCESS_TOKEN`: Rollbar token, needed to log errors in production.




Opcionalmente se puede fijar también la variable `PORT` para cambiar el puerto donde el servidor web escucha (por defecto es el 80). Ver `config/puma.rb` para más opciones que pueden ser ajustadas o sobre-escritas mediante variables de entorno.

Juntando todo lo anterior, el siguiente comando es un ejemplo para levantar la aplicación en producción:

    $ docker run \
        -p 8888:80 \
        -e SECRET_KEY_BASE=myprecioussecret \
        -e DATABASE_URL=postgres://user:password@host/database \
        -e CHILEATIENDE_TOKEN=MyChileAtiendeApiKey \\
        # Etc, etc, more env variables here \
        egob/totems-autoatencion

## Despliegue

Además de descargar y ejecutar la imagen `egob/plataforma-kioscos-autoatencion` desde DockerHub y apuntar el balanceador de carga a los contenedores que ejecutan esta imagen (según lo descrito anteriormente), una nueva versión de la aplicación puede contener cambios den la base de datos.

Estos cambios deben ser aplicados **antes** de lanzar los nuevos contenedores. Para realizar dichos cambios, se debe utilizar la misma imagen `egob/plataforma-kioscos-autoatencion` pero ejecutando el siguiente comando: `bundle exec rake db:create db:migrate`

Este sera un ejemplo de la línea de comando completa:

    $ docker run \
        -p 8888:80 \
        -e SECRET_KEY_BASE=myprecioussecret \
        -e DATABASE_URL=postgres://user:password@host/database \
        -e CHILEATIENDE_TOKEN=MyChileAtiendeApiKey \\
        # Etc, etc, more env variables here \
        egob/totems-autoatencion \
        bundle exec rake db:create db:migrate

Además se puede agregar el flag `--rm` a dicho comando para eliminar este contenedor desechable inmediatamente después de su ejecución.

## Administración

El sistema cuenta con un backend de administración y dashboards

Para generar un usuario administrador se debe ejecutar:

    make admin

Una vez creado el usuario administrador se puede acceder en el path /admin (por ej: https://kioscos.digital.gob.cl/admin)

    - User: admin@example.com
    - Password: password

## Para iniciar el proyecto en modo desarrollo

- Tener funcional el proyecto MatchOnCard[https://github.com/e-gob/MatchOnCard]
- Ejecutar el comando "make admin" para crear un administrador
- En el admin (http://servidor/admin), crear un totem con los siguientes dato

    tid: LOCAL-GD-01

    rut: rut del usuario con clave unica

    activo: true

    location: PRUEBA

    location type: ministerial_office


# Para imprimir certificados

- Tener funcional el proyecto https://github.com/e-gob/plataforma-kioscos-autoatencion-print
El servicio de impresión debe ejecutarse en la maquina conectada a la impresora,
el totem se comunica mediante un api REST en localhost

# Para monitorear si la aplicación cliente totem está activa

- Se requiere tener en funcionamiento el script de monitoreo incluido en
$RAIZ_DEL_REPO/scripts/monitor/src. Se incluyen instrucciones en el README.md ubicado en ese directorio sobre como levantar
un kiosk desde cero junto con el script de monitoreo.
