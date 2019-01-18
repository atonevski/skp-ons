# 
# clouds.coffee: map with clouds
#

window.fn.loadClouds = () ->
  content = $('#content')[0]
  menu = $('#menu')[0]

  content.load 'views/clouds.html'
         .then menu.close.bind(menu)
         .then renderClouds
map = null

renderClouds = () ->
  $('ons-page#clouds-page')[0].addEventListener 'destroy', () ->
    console.log 'destroying clouds page...'
    if map?
      map.remove()
      map = null

  $('ons-page#clouds-page')[0].addEventListener 'init', () ->
    console.log 'init clouds...'

  $('ons-page#clouds-page')[0].addEventListener 'hide', () ->
    console.log 'hide clouds...'

  # OWM api id
  APPID = '74caac32fcc2d61b715c249e789a875e'

  osm = L.tileLayer 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 18
    attribution: 'some attribution'
    # id: 'mapbox.streets'
  }

  map = L.map "map-id", {
    center: new L.LatLng(42, 21.43)
    zoom: 6
    layers: [osm]
  }
      
  # osm.addTo $scope.map
  clouds  = L.OWM.clouds { showLegend: false, opacity: 0.65, appId: APPID }
  city    = L.OWM.current {intervall: 15, lang: 'mk'}

  baseMaps      = { "OSM Standard": osm }
  overlayMaps   = { "Clouds": clouds, "Cities": city }
  layerControl  = L.control.layers(baseMaps, overlayMaps).addTo(map)


  map.on 'locationerror', (e) -> console.log "Leaflet loc err: ", e
