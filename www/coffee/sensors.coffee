#
# MAP
#
# Leaflet MAP

window.fn.sensorMap = null

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

  if window.fn.selected is 'sensors'
    menu.close.bind(menu)()
    return

  content.load 'views/sensors.html'
         .then menu.close.bind(menu)
         .then () ->
           renderSensors()

getMarkerIcon = (level) ->
  level = Math.round level
  switch
    when   0 <= level < 50
      1
    when    50 <= level <  100
      2
    when   100 <= level <  250
      3
    when   250 <= level <  350
      4
    when   350 <= level <  430
      5
    when   430 <= level < 2000
      5
    else
      0

window.fn.markerIcons = [
  L.icon({
    iconUrl: 'css/images/marker-icon-lgray.png'
    shadowUrl: 'css/images/marker-shadow.png'
    iconSize: [25, 41]
    shadowSize: [41, 41]
    iconAnchor: [12, 41]
    popupAnchor: [0, -43]})
  ,
  L.icon({
    iconUrl: 'css/images/marker-icon-green.png'
    shadowUrl: 'css/images/marker-shadow.png'
    iconSize: [25, 41]
    shadowSize: [41, 41]
    iconAnchor: [12, 41]
    popupAnchor: [0, -43]})
  ,
  L.icon({
    iconUrl: 'css/images/marker-icon-yellow.png'
    shadowUrl: 'css/images/marker-shadow.png'
    iconSize: [25, 41]
    shadowSize: [41, 41]
    iconAnchor: [12, 41]
    popupAnchor: [0, -43]})
  ,
  L.icon({
    iconUrl: 'css/images/marker-icon-orange.png'
    shadowUrl: 'css/images/marker-shadow.png'
    iconSize: [25, 41]
    shadowSize: [41, 41]
    iconAnchor: [12, 41]
    popupAnchor: [0, -43]})
  ,
  L.icon({
    iconUrl: 'css/images/marker-icon-red.png'
    shadowUrl: 'css/images/marker-shadow.png'
    iconSize: [25, 41]
    shadowSize: [41, 41]
    iconAnchor: [12, 41]
    popupAnchor: [0, -43]})
  ,
  L.icon({
    iconUrl: 'css/images/marker-icon-violet.png'
    shadowUrl: 'css/images/marker-shadow.png'
    iconSize: [25, 41]
    shadowSize: [41, 41]
    iconAnchor: [12, 41]
    popupAnchor: [0, -43]})
]


renderSensors = () ->
  window.fn.selected = 'sensors'
  
  CENTER = [ 41.99249998, 21.42361109 ]
  CITY = 'skopje'
  USERNAME = "atonevski"
  PASSWORD = "pv1530kay"

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
          typeInfo = {}
          for p in params
            paramData = s.data
                         .filter (v) -> v.type is p and v.value?
                         .map (x) -> parseInt x.value

            # console.log p, paramData
            curr = paramData[-1..][0]
            min = paramData.reduce (a, v) ->
              unless v?
                a
              else
                if v < a then v else a
            , paramData[0]
            max = paramData.reduce (a, v) ->
              unless v?
                a
              else
                if v > a then v else a
            , paramData[0]
            acc = paramData.reduce (a, v) ->
              unless v?
                a
              else
                { sum: a.sum + v, count: a.count + 1 }
            , { sum: 0, count: 0}
            avg = if acc.count > 0 then acc.sum / acc.count else null
            typeInfo[p] = curr: curr, min: min, max: max, avg: avg, data: paramData

          s.params = params
          s.typeInfo = typeInfo
          # console.log s
          html = """
            <table>
              <caption>#{ s.name }</captio>
              <thead><tr>
                <th>parameter</th>
                <th class='center'>current</th>
                <th class='center'>min</th>
                <th class='center'>max</th>
                <th class='center'>avg</th>
                <th class='center'>samples</th>
              </tr></thead>
              <tbody>
          """
          for t, v of s.typeInfo
            html += """
              <tr>
                <td align='left'>#{ t }</td>
                <td align='center'>#{ v.curr }</td>
                <td align='center'>#{ v.min }</td>
                <td align='center'>#{ v.max }</td>
                <td align='center'>#{ v.avg.toFixed 2 }</td>
                <td align='center'>#{ v.data.length }</td>
              </tr>
            """
          html += """
            </tbody>
            </table>
          """
          if s.data.length > 0
            html += """
              <p>
                Interval:
                  <span style='font-size: 75%'>#{ s.data[0].stamp[0..18] } &ndash;
                   #{ s.data[-1..][0].stamp[0..18] }</span>
              </p>
            """
          i = if s.typeInfo['pm10']? and s.typeInfo['pm10'].curr?
                getMarkerIcon s.typeInfo.pm10.curr
              else
                0
          marker = L.marker pos, { icon: window.fn.markerIcons[i] }
            .addTo window.fn.sensorMap
            .bindPopup html

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

      # console.log window.fn.sensors

      # here we should create the marker for sensor...
      for id, s of  window.fn.sensors
        pos = parsePos s.position
        # filter unique type/param values
        params = s.data
                  .map (x) -> x.type
                  .filter (v, i, self) -> self.indexOf(v) is i
        marker = L.marker pos
          .addTo window.fn.sensorMap
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

  renderMap = () ->
    window.fn.sensorMap = L.map 'map-id'
          .setView CENTER, 12

    # L.tileLayer 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', { }
    L.tileLayer 'http://{s}.tile.osm.org/{z}/{x}/{y}.png', {}
    .addTo window.fn.sensorMap

    # added for lat/lngs
    window.fn.sensorMap.on 'click', (e) ->
      ons.notification.alert "Pos: (#{ e.latlng.lat }, #{ e.latlng.lng })"
      console.log "Pos: (#{ e.latlng.lat }, #{ e.latlng.lng })"

    getSensors()

  renderMap()
