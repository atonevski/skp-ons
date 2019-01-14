// Generated by CoffeeScript 2.3.2

// MAP

// Leaflet MAP
var CENTER, CITY, PASSWORD, USERNAME, getSensors, map, parsePos, renderMap, sensors;

map = null;

CENTER = [41.99249998, 21.42361109];

CITY = 'skopje';

USERNAME = "atonevski";

PASSWORD = "pv1530kay";

sensors = [];

parsePos = function(s) {
  return s.split(/\s*,\s*/).map(function(v) {
    return parseFloat(v);
  });
};

getSensors = function() {
  return $.ajax({
    url: `https://${CITY}.pulse.eco/rest/sensor`,
    method: 'GET',
    username: USERNAME,
    password: PASSWORD
  }).done(function(d) {
    var i, len, marker, pos, results, s;
    console.log(d);
    sensors = d;
    results = [];
    for (i = 0, len = sensors.length; i < len; i++) {
      s = sensors[i];
      pos = parsePos(s.position);
      results.push(marker = L.marker(pos).addTo(map).bindPopup(`<p>Sensor: ${s.description}</p>`));
    }
    return results;
  });
};

renderMap = function() {
  map = L.map('map-id').setView(CENTER, 12);
  // L.tileLayer 'http://{s}.tile.osm.org/{z}/{x}/{y}.png', {}
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {}).addTo(this.map);
  console.log(`base64: ${btoa('abc')}`);
  return getSensors();
};

renderMap();