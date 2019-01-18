#
# clouds.coffee: map with clouds
#

window.fn.cloudMap = null

window.fn.loadClouds = () ->
  content = $('#content')[0]
  menu = $('#menu')[0]

  if window.fn.selected is 'clouds'
    menu.close.bind(menu)()
    return

  content.load 'views/clouds.html'
         .then menu.close.bind(menu)
         .then () ->
            $('ons-page#clouds-page')[0].addEventListener 'destroy', () ->
              window.fn.cloudMap.remove()
              console.log 'destroying clouds page...'
            $('ons-page#clouds-page')[0].addEventListener 'init', () ->
              console.log 'init clouds page...'
            $('ons-page#clouds-page')[0].addEventListener 'hide', () ->
              console.log 'hide clouds page...'
            $('ons-page#clouds-page')[0].addEventListener 'show', () ->
              console.log 'show clouds page...'
         .then renderClouds

renderClouds = () ->
  window.fn.selected = 'clouds'

  $('[id$="_opt]"').each (i) -> console.log @getAttribute('tappable')

  # OWM api id
  APPID = '74caac32fcc2d61b715c249e789a875e'

  osm = L.tileLayer 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 18
    attribution: 'some attribution'
    # id: 'mapbox.streets'
  }

  oldMap = window.fn.cloudMap
  window.fn.cloudMap = L.map "cloud-map-id", {
    center: new L.LatLng(42, 21.43)
    zoom: 6
    layers: [osm]
  }

  # osm.addTo $scope.map
  clouds  = L.OWM.clouds { showLegend: true, opacity: 0.65, appId: APPID }
  precip  = L.OWM.precipitation { appId: APPID }
  city    = L.OWM.current {intervall: 15, lang: 'mk'}

  baseMaps      = { "OSM Standard": osm }
  overlayMaps   = { Clouds: clouds, Precipitation: precip }
  layerControl  = L.control.layers(baseMaps, overlayMaps).addTo(window.fn.cloudMap)


  window.fn.cloudMap.on 'locationerror', (e) -> console.log "Leaflet loc err: ", e
