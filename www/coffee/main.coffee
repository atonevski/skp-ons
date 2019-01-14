window.fn = { }

window.fn.open = () ->
  menu = $('#menu')[0]
  menu.open()

window.fn.load = (page) ->
  content = $('#content')[0]
  menu = $('#menu')[0]

  content.load page
         .then menu.close.bind(menu)

window.fn.loadSensors = () ->
  content = $('#content')[0]
  menu = $('#menu')[0]

  content.load 'views/sensors.html'
         .then menu.close.bind(menu)
         .then () ->
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
              .addTo map

              console.log "base64: #{ btoa 'abc' }"
              getSensors()
            renderMap()


# # 1st experimental code
# # - maps
# # - get sensors
# # - some formatting
# # - etc.
# #
# showAlert = (m) ->
#   ons.notification.alert m
# 
# showToast = (m) ->
#   t = 2000
#   t = arguments[1] if arguments.length > 1
#   ons.notification.toast m, timeout: t
# 
# # formats Date to "YYYY-mm-ddTHH:MM:SS[+|-]HH:MM"
# toDTM = (d) ->
#   throw "#{ d } is not Date()" unless d instanceof Date
#   dd = (new Date(d - d.getTimezoneOffset()*1000*60))
#   ymd= dd.toISOString()[0..9]
#   re = /(\d\d:\d\d:\d\d) GMT([-+]\d+)/gm
#   s = re.exec d.toString()
#   "#{ ymd }T#{ s[1] }#{ s[2][0..2] }:#{ s[2][3..4] }"
# 
# #
# # MAP
# #
# # Leaflet MAP
# map = null
# CENTER = [ 41.99249998, 21.42361109 ]
# CITY = 'skopje'
# USERNAME = "atonevski"
# PASSWORD = "pv1530kay" 
# sensors = []
# 
# parsePos = (s) ->
#   s.split /\s*,\s*/
#     .map (v) -> parseFloat(v)
# 
# getSensors = () ->
#   $.ajax
#     url: "https://#{ CITY }.pulse.eco/rest/sensor"
#     method: 'GET'
#     username: USERNAME
#     password: PASSWORD
#   .done (d) ->
#     console.log d
#     sensors = d
#     for s in sensors
#       pos = parsePos s.position
#       marker = L.marker pos
#         .addTo map
#         .bindPopup "<p>Sensor: #{ s.description }</p>"
#       
#     
# 
# renderMap = () ->
#   map = L.map 'map-id'
#          .setView CENTER, 12
#  
#   L.tileLayer 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', { }
#   # L.tileLayer 'http://{s}.tile.osm.org/{z}/{x}/{y}.png', {}
#   .addTo map
# 
#   console.log "base64: #{ btoa 'abc' }"
#   getSensors()
# renderMap()
