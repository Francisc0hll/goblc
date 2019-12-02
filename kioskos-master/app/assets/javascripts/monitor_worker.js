function send_signal(totem_id, url, monitoring_interval, last_sign) {
  var ping_time, interval, totem_tid;
  ping_time = new Date();
  interval = monitoring_interval;
  totem_tid = totem_id;
  if (last_sign === null) {
    interval += Math.abs(totem_tid.hashCode() % interval);
  } else {
   interval -= (ping_time.getTime() - parseInt(last_sign));
  }
  setTimeout(function() {
    console.log('Init Ping');
    ping_time = new Date();
    var xhr = new XMLHttpRequest();
    xhr.open('POST', url+'/totem_monitors');
    xhr.setRequestHeader("Content-Type", "application/json");
    xhr.onload = function() {
      if (xhr.status !== 200) {
        console.log('Totem Monitor ERROR');
      } else {
        console.log('Totem Monitor SUCCESS');
      }
    };
    xhr.send(JSON.stringify({
      totem_tid: totem_id,
      ping_time: ping_time.toISOString()
    }));
    postMessage(ping_time.getTime());
    send_signal(totem_id, url, monitoring_interval, ping_time.getTime());
  }, interval);
}

String.prototype.hashCode = function() {
  var hash = 0, i, chr;
  if (this.length === 0) return hash;
  for (i = 0; i < this.length; i++) {
    chr   = this.charCodeAt(i);
    hash  = ((hash << 5) - hash) + chr;
    hash |= 0; // Convert to 32bit integer
  }
  return hash;
}

onmessage = function(e) {
  send_signal(e.data[0], e.data[1], e.data[2], e.data[3]);
}

console.log('starting monitor');
