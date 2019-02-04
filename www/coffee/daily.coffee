#
# daily.coffee: show daily forecast
#

window.fn.loadDaily = () ->
  content = $('#content')[0]
  menu = $('#menu')[0]

  if window.fn.selected is 'daily'
    menu.close.bind(menu)()
    return

  content.load 'views/daily.html'
         .then menu.close.bind(menu)
         .then () -> renderDaily()

moonPhaseIcon = (v) -> # v: 0..1
  v = Math.floor 28 * v
  switch
    when v is 0
      'wi-moon-new'
    when 0 < v < 7
      "wi-moon-waxing-crescent-#{ v }"
    when v is 7
      'wi-moon-first-quarter'
    when 7 < v < 14
      "wi-moon-waxing-gibbous-#{ v - 7 }"
    when v is 14
      'wi-moon-full'
    when 14 < v < 21
      "wi-moon-waning-gibbous-#{ v - 14 }"
    when v is 21
      'wi-moon-third-quarter'
    when 21 < v < 28
      "wi-moon-waning-crescent-#{ v - 21 }"
    else
      "wi-na"

dailyPrev = () -> $('#carousel')[0].prev()

dailyNext = () -> $('#carousel')[0].next()

renderDaily = () ->
  window.fn.selected = 'daily'

  KEY = '6376c1cdba2fa461f346e9a27524406d'
  LAT = 42
  LNG = 21.43
  url = "https://api.darksky.net/forecast/#{ KEY}/#{ LAT },#{ LNG }?units=si"
  $.ajax
    url: url
    method: 'GET'
  .done (d) ->
    console.log d
    window.fn.weather = d

    carousel = $('#carousel')[0] # $('#carousel')
    # carousel.empty()

    for i, dd of d.daily.data
      citem = ons.createElement """
        <ons-carousel-item>
          <ons-card>
            <div class='title'>
              #{ (new Date dd.time*1000).toString()[0..14] }
              <i class='wi #{ weatherIconFor dd.icon }'></i>
            </div>
            <div class='content'>
              <ons-list>
                <ons-list-item class='open-sans'>
                  <div class="left">
                    <ons-icon class="list-item__icon">
                      <i class='wi wi-thermometer'></i>
                    </ons-icon>
                  </div>
                  <div class='center'>
                    <strong>Temperature:</strong>&nbsp;
                      #{ Math.round dd.temperatureMin }&deg;C /
                      #{ Math.round dd.temperatureMax }&deg;C
                  </div>
                </ons-list-item>
                <ons-list-item class='open-sans' modifier='nodivider noborder'>
                  <div class="left">
                    <ons-icon class="list-item__icon">
                      <i class='wi #{ weatherIconFor dd.icon }'></i>
                    </ons-icon>
                  </div>
                  <div class='center'>
                    <strong>Summary:</strong>&nbsp;
                    #{ dd.summary }
                  </div>
                </ons-list-item>
                <ons-list-item class='open-sans' modifier='nodivider noborder'>
                  <div class="left">
                    <ons-icon class="list-item__icon">
                      <i class='wi wi-humidity'></i>
                    </ons-icon>
                  </div>
                  <div class='center'>
                    <strong>Humidity:</strong>&nbsp;
                    #{ Math.round dd.humidity*100 }%
                  </div>
                </ons-list-item>
                <ons-list-item class='open-sans'>
                  <div class="left">
                    <ons-icon class="list-item__icon">
                      <i class='wi wi-barometer'></i>
                    </ons-icon>
                  </div>
                    <strong>Pressure:</strong>&nbsp;
                    #{ Math.round dd.pressure }&nbsp;hPa
                </ons-list-item>
                <ons-list-item class='open-sans'>
                  <div class="left">
                    <ons-icon class="list-item__icon">
                      <i class='wi wi-day-cloudy-high'></i>
                    </ons-icon>
                  </div>
                    <strong>Cloud cover:</strong>&nbsp;
                    #{ Math.round dd.cloudCover*100 }%
                </ons-list-item>
                <ons-list-item class='open-sans'>
                  <div class="left">
                    <ons-icon class="list-item__icon">
                      <i class="far fa-eye"></i>
                    </ons-icon>
                  </div>
                    <strong>Visibility:</strong>&nbsp;
                    #{ dd.visibility }&nbsp;km
                </ons-list-item>
                <ons-list-item class='open-sans'>
                  <div class="left">
                    <ons-icon class="list-item__icon">
                      <i class='wi wi-raindrops'></i>
                    </ons-icon>
                  </div>
                  <div class='center'>
                    <strong>Precipitation:</strong>&nbsp;
                    #{ Math.round dd.precipProbability*100 }%
                  </div>
                </ons-list-item>
                <ons-list-item class='open-sans'>
                  <div class="left">
                    <ons-icon class="list-item__icon">
                      <i class='wi wi-strong-wind'></i>
                    </ons-icon>
                  </div>
                  <div class='center'>
                    <strong>Wind:</strong>&nbsp;
                    #{  (3.6 * dd.windSpeed).toFixed(2) }&nbsp;km/h
                    &nbsp;<i class='wi wi-wind #{ windBearingIcon dd.windBearing }'></i>
                  </div>
                </ons-list-item>
                <ons-list-item class='open-sans'>
                  <div class="left">
                    <ons-icon icon="fa-sun" class="list-item__icon"></ons-icon>
                  </div>
                  <div class='center'>
                    <strong>UV index:</strong>&nbsp;
                    #{ dd.uvIndex } /&nbsp;
                    <strong>Ozone:</strong>&nbsp;
                    #{  Math.round dd.ozone }&nbsp;
                  </div>
                </ons-list-item>
                <ons-list-item class='open-sans' modifier='nodivider'>
                  <div class="left">
                    <ons-icon class="list-item__icon">
                      <i class="wi wi-sunrise"></i>
                    </ons-icon>
                  </div>
                  <div class='center'>
                    <strong>Sunrise/Sunset:</strong>&nbsp;
                    <small>#{ (new Date dd.sunriseTime*1000).toString()[16..23] }</small> /
                    <small>#{ (new Date dd.sunsetTime*1000).toString()[16..23] }</small>
                  </div>
                </ons-list-item>
                <ons-list-item class='open-sans' modifier='nodivider noborder'>
                  <div class="left">
                    <ons-icon class="list-item__icon">
                      <i class='wi #{ moonPhaseIcon dd.moonPhase }'></i>
                    </ons-icon>
                  </div>
                  <div class='center'><strong>Moon phase:</strong>&nbsp;
                  #{ Math.floor dd.moonPhase*28 }
                  </div>
                </ons-list-item>
              </ons-list>
            </div>
          </ons-card>
        </ons-carousel-item>
      """
      carousel.appendChild citem
    carousel.refresh()
