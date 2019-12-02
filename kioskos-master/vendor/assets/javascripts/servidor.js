/**
 * Created by utaladriz on 04-01-17.
 */
function WSSocketConstructor(token, funcion){
    this.token = token;
    this.funcion = funcion;
    this.log = function(mensaje, data){
        if (this.debug){
            if (mensaje) console.log("wssocket: "+mensaje);
            if (data) console.log(data);
        }
    };

    this.cerrar = function(){
        if (this.socket && (this.socket.readyState == 1)) {
            window.clearInterval(this.timer);
            this.timer = undefined;
            this.intentos = 0;
            this.socket.onclose = undefined;
            this.socket.close();
            this.log("Cerrado");
            this.socket = undefined;
        }
    };

    this.estaAbierto = function(){
        return this.socket && (this.socket.readyState == 1);
    };

    this.enviar = function(data){
        if (this.socket &&  (this.socket.readyState == 1)) {
            this.socket.send(JSON.stringify(data));
            this.log("Enviando", data);
        }
        else
            throw new Error("wssocket: Socket no está abierto");
    };

    this.onerror = function (evento) {
        this.wssocket.intentos++;
        this.wssocket.log("Error " + this.wssocket.intentos + " intentos", evento);
        if (this.wssocket.intentos >= this.wssocket.reintentos)
            this.wssocket.cerrar();

    };

    this.onclose = function () {
        this.wssocket.cerrar();
    };

    this.onopen = function (evento) {
        this.wssocket.log("Abierto",evento);
        this.wssocket.timer = window.setInterval(function () {
            this.wssocket.enviar({"token":this.wssocket.token,"comando": "eco"})
        }, this.wssocket.tiempoeco);
    };



    this.onmessage = function (event) {
        var data = JSON.parse(event.data)
        this.wssocket.log("Mensaje", data);
        if (data.tipo != "eco")
            this.wssocket.funcion(data);
    };



    this.conectar = function() {
        if (!this.reintentos)
            this.reintentos = 3;
        if (!this.tiempoeco)
            this.tiempoeco = 5000;
        this.intentos = 0;
        this.socket = new WebSocket("ws://localhost:8082/api/canal");
        this.socket.wssocket = this;

        this.socket.onerror = this.onerror;
        this.socket.onclose = this.onclose;
        this.socket.onopen = this.onopen;
        this.socket.onmessage = this.onmessage;
        window.onbeforeunload = this.cerrar;
    };



};





