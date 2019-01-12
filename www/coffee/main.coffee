showAlert = (m) ->
  ons.notification.alert m

showToast = (m) ->
  t = 2000
  t = arguments[1] if arguments.length > 1
  ons.notification.toast m, timeout: t

map = null
CENTER = [ 41.99249998, 21.42361109 ]

renderMap = () ->
  map = L.map 'map-id'
         .setView CENTER, 12
 
  L.tileLayer 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', { }
  # L.tileLayer 'http://{s}.tile.osm.org/{z}/{x}/{y}.png', {}
  .addTo @map

  console.log "base64: #{ atob 'abc' }"
renderMap()
