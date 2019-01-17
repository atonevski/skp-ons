#
# MAP
#
# Leaflet MAP

window.fn.sensors =
  "1002": { name: 'Миладиновци' }
  "11888f3a-bc5e-4a0c-9f27-702984decedf": { name: 'МЗТ' }
  "01440b05-255d-4764-be87-bdf135f32289": { name: 'Бардовци' }
  "bb948861-3fd7-47dd-b986-cb13c9732725": { name: 'Бисер' }
  "cec29ba1-5414-4cf3-bbcc-8ce4db1da5d0": { name: 'Алуминка' }
  "1005": { name: 'Ректорат' }
  "bc9f31ea-bf3d-416c-86b5-ecba6e98bb24": { name: 'Фонтана' }
  "66710fdc-cdfc-4bbe-93a8-7e796fb8a88d": { name: 'Козле' }
  "24eaebc2-ca62-49ff-8b22-880bc131b69f": { name: 'Црниче' }
  "b79604bb-0bea-454f-a474-849156e418ea": { name: 'Драчево' }
  "1004": { name: 'Газибаба' }
  "fc4bfa77-f791-4f93-8c0c-62d8306c599c": { name: 'Нерези' }
  "cfb0a034-6e29-4803-be02-9215dcac17a8": { name: 'Ѓорче Петров' }
  "1003": { name: 'Карпош' }
  "200cdb67-8dc5-4dcf-ac62-748db636e04e": { name: '11ти Октомври' }
  "8d415fa0-77dc-4cb3-8460-a9159800917f": { name: 'СД Гоце Делчев' }
  "b80e5cd2-76cb-40bf-b784-2a0a312e6264": { name: 'Станица Ѓорче' }
  "6380c7cc-df23-4512-ad10-f2b363000579": { name: 'Сопиште' }
  "eaae3b5f-bd71-46f9-85d5-8d3a19c96322": { name: 'Карпош 2' }
  "7c497bfd-36b6-4eed-9172-37fd70f17c48": { name: 'Железара' }
  "1000": { name: 'Центар' }
  "3d7bd712-24a9-482c-b387-a8168b12d3f4": { name: 'Бутел 1' }
  "5f718e32-5491-4c3c-98ff-45dc9e287df4": { name: 'Водно' }
  "e7a05c01-1d5c-479a-a5a5-419f28cebeef": { name: 'Излет' }
  "1001": { name: 'Лисиче'}
  "8ad9e315-0e23-4dc0-a26f-ba5a17d4d7ed": { name: 'Аеродром'}
  "680b0098-7c4d-44cf-acb1-dc4031e93d34": { name: 'Илинден'}

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
            
            toDTM = (d) ->
              throw "#{ d } is not Date()" unless d instanceof Date
              dd = (new Date(d - d.getTimezoneOffset()*1000*60))
              ymd= dd.toISOString()[0..9]
              re = /(\d\d:\d\d:\d\d) GMT([-+]\d+)/gm
              s = re.exec d.toString()
              "#{ ymd }T#{ s[1] }#{ s[2][0..2] }:#{ s[2][3..4] }"

            getLast24h = () ->
              for id, s of window.fn.sensors
                do(id, s) =>
                  #...
                  to = new Date()
                  from = new Date to - 24*60*60*1000
                  url = "https://#{ CITY }.pulse.eco/rest/dataRaw?" +
                        "sensorId=#{ id }&" +
                        "from=#{ encodeURIComponent toDTM(from) }&" +
                        "to=#{ encodeURIComponent toDTM(to) }"
                  # console.log url
                  $.ajax
                    url: url
                    method: 'GET'
                    username: USERNAME
                    password: PASSWORD
                    dataType: "json"
                    headers:
                      "Authorization": "Basic " + btoa(USERNAME + ":" + PASSWORD)
                  .done (d) =>
                    # console.log s
                    # window.fn.sensors[id].data = data
                    s.data = d
                    # here we should create the marker for sensor...
                    pos = parsePos s.position
                    # filter unique type/param values
                    params = s.data 
                              .map (x) -> x.type
                              .filter (v, i, self) -> self.indexOf(v) is i
                    marker = L.marker pos
                      .addTo map
                      .bindPopup """
                        <p>Sensor: #{ s.name }</p>
                        <p>Parameters: #{ params.join(', ') }</p>
                      """
                  
            get24h = () ->
              # instead use loop over sensors & retreive data
              # when tested put this code in a separate function
              $.ajax
                url: "https://#{ CITY }.pulse.eco/rest/data24h"
                method: 'GET'
                username: USERNAME
                password: PASSWORD
              .done (d) ->
                # console.log d
                # we assume we have loaded sensors data
                for id, s of  window.fn.sensors
                  data = d.filter (x) -> x.sensorId is id
                  window.fn.sensors[id].data = data

                console.log window.fn.sensors

                # here we should create the marker for sensor...
                for id, s of  window.fn.sensors
                  pos = parsePos s.position
                  # filter unique type/param values
                  params = s.data 
                            .map (x) -> x.type
                            .filter (v, i, self) -> self.indexOf(v) is i
                  marker = L.marker pos
                    .addTo map
                    .bindPopup """
                      <p>Sensor: #{ s.name }</p>
                      <p>Parameters: #{ params.join(', ') }</p>
                    """
                  
            getSensors = () ->
              $.ajax
                url: "https://#{ CITY }.pulse.eco/rest/sensor"
                method: 'GET'
                username: USERNAME
                password: PASSWORD
              .done (d) ->
                # console.log d
                for s in d
                  if window.fn.sensors[s.sensorId]?
                    window.fn.sensors[s.sensorId].position = s.position
                    window.fn.sensors[s.sensorId].description = s.description
                    window.fn.sensors[s.sensorId].coments = s.coments
                  else
                    window.fn.sensors[s.sensorId] = s
                    window.fn.sensors[s.sensorId].name = s.description


                sensors = d
                # get24h()
                getLast24h()

                # for id, s of  window.fn.sensors
                #   pos = parsePos s.position
                #   marker = L.marker pos
                #     .addTo map
                #     .bindPopup "<p>Sensor: #{ s.name }</p>"

            renderMap = () ->
              map = L.map 'map-id'
                    .setView CENTER, 12

              L.tileLayer 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', { }
              # L.tileLayer 'http://{s}.tile.osm.org/{z}/{x}/{y}.png', {}
              .addTo map

              console.log "base64: #{ btoa 'abc' }"
              getSensors()
            renderMap()
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
#   .addTo @map
#
#   console.log "base64: #{ btoa 'abc' }"
#   getSensors()
#
# renderMap()
