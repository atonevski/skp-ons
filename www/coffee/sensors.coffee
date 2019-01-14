#
# MAP
#
# Leaflet MAP
map = null
CENTER = [ 41.99249998, 21.42361109 ]
CITY = 'skopje'
USERNAME = "atonevski"
PASSWORD = "pv1530kay" 
sensors = []

parsePos = (s) ->
  s.split /\s*,\s*/
    .map (v) -> parseFloat(v)

getSensors = () ->
  $.ajax
    url: "https://#{ CITY }.pulse.eco/rest/sensor"
    method: 'GET'
    username: USERNAME
    password: PASSWORD
  .done (d) ->
    console.log d
    sensors = d
    for s in sensors
      pos = parsePos s.position
      marker = L.marker pos
        .addTo map
        .bindPopup "<p>Sensor: #{ s.description }</p>"
      
    

renderMap = () ->
  map = L.map 'map-id'
         .setView CENTER, 12
 
  L.tileLayer 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', { }
  # L.tileLayer 'http://{s}.tile.osm.org/{z}/{x}/{y}.png', {}
  .addTo @map

  console.log "base64: #{ btoa 'abc' }"
  getSensors()
renderMap()
