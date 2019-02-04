window.fn = { }

window.fn.selected = 'home'

window.fn.open = () ->
  menu = $('#menu')[0]
  menu.open()

window.fn.load = (page) ->
  content = $('#content')[0]
  menu = $('#menu')[0]

  content.load page
         .then menu.close.bind(menu)

window.fn.loadHome = () ->
  content = $('#content')[0]
  menu = $('#menu')[0]

  content.load 'views/home.html'
         .then menu.close.bind(menu)
         .then () -> renderHome()

# miles per hour to kilometers per hour
mph2kmph = (m) -> m * 1.609344

# meters per second to kilometers per hour
mps2kmph = (m) -> 3600.0 * m / 1000

weatherIconFor = (i) ->
  switch i
    when 'clear-day'    then 'wi-day-sunny'
    when 'clear-night'  then 'wi-night-clear'
    when 'rain'         then 'wi-rain'
    when 'snow'         then 'wi-snow'
    when 'sleet'        then 'wi-sleet'
    when 'wind'         then 'wi-strong-wind'
    when 'fog'          then 'wi-fog'
    when 'cloudy'       then 'wi-cloudy'
    when 'partly-cloudy-day'    then 'wi-day-cloudy'
    when 'partly-cloudy-night'  then 'wi-night-alt-partly-cloudy'
    when 'hail'         then 'wi-hail'
    when 'thunderstorm' then 'wi-thunderstorm'
    when 'tornado'      then 'wi-tornado'
    else 'wi-na'

windBearingIcon = (b) ->
  switch
    when   0 <= b <  23
      'from-0-deg'
    when  23 <= b <  45
      'from-23-deg'
    when  45 <= b <  68
      'from-45-deg'
    when  68 <= b <  90
      'from-68-deg'
    when  90 <= b < 113
      'from-90-deg'
    when 113 <= b < 135
      'from-113-deg'
    when 135 <= b < 158
      'from-135-deg'
    when 158 <= b < 180
      'from-158-deg'
    when 180 <= b < 203
      'from-180-deg'
    when 203 <= b < 225
      'from-203-deg'
    when 225 <= b < 248
      'from-225-deg'
    when 248 <= b < 270
      'from-248-deg'
    when 270 <= b < 293
      'from-270-deg'
    when 293 <= b < 313
      'from-293-deg'
    when 313 <= b < 336
      'from-313-deg'
    when 336 <= b
      'from-336-deg'

renderHome = () ->
  window.fn.selected = 'home'

  KEY = '6376c1cdba2fa461f346e9a27524406d'
  LAT = 42
  LNG = 21.43
  url = "https://api.darksky.net/forecast/#{ KEY}/#{ LAT },#{ LNG }?units=si"
  $.ajax
    url: url
    method: 'GET'
  .done (d) ->
    # console.log d
    window.fn.weather = d
    $('p#temp').html "#{ Math.round d.currently.temperature }&deg;C"

    rtitle = $('div#home-title-right').empty()
    rtitle.html """
      <i class='wi #{ weatherIconFor d.currently.icon }'></i>
      <span>#{ Math.round d.currently.temperature }&deg;C</span>
    """

    list = $('ons-list#current-values')
    list.empty()

    # time
    item = ons.createElement """
      <ons-list-item class='open-sans'>
        <div class="left">
          <ons-icon class="list-item__icon">
            <i class="wi wi-time-10"></i>
          </ons-icon>
        </div>
        <div class='center'>
          <strong>Time:</strong>&nbsp;
          <small>
            #{ (new Date d.currently.time*1000).toString()[0..23] }&nbsp;
            #{ d.timezone }
          </small>
        </div>
      </ons-list-item>
    """
    list.append item

    # summary
    item = ons.createElement """
      <ons-list-item class='open-sans'>
        <div class="left">
          <ons-icon class="list-item__icon">
            <i class='wi #{ weatherIconFor d.currently.icon }'></i>
          </ons-icon>
        </div>
        <div class='center'>
          <strong>Summary:</strong>&nbsp;
          #{ d.currently.summary }
        </div>
      </ons-list-item>
    """
    list.append item

    # apparent temp.
    item = ons.createElement """
      <ons-list-item class='open-sans'>
        <div class="left">
          <ons-icon class="list-item__icon">
            <i class='wi wi-thermometer'></i>
          </ons-icon>
        </div>
        <div class='center'>
          <strong>Apparent temperature:</strong>&nbsp;
            #{ Math.round d.currently.apparentTemperature }&degC;
        </div>
      </ons-list-item>
    """
    list.append item

    # humidity
    item = ons.createElement """
      <ons-list-item class='open-sans'>
        <div class="left">
          <ons-icon class="list-item__icon">
            <i class='wi wi-humidity'></i>
          </ons-icon>
        </div>
        <div class='center'>
          <strong>Humidity:</strong>&nbsp;
          #{ Math.round d.currently.humidity*100 }%
        </div>
      </ons-list-item>
    """
    list.append item

    # pressure
    item = ons.createElement """
      <ons-list-item class='open-sans'>
        <div class="left">
          <ons-icon class="list-item__icon">
            <i class='wi wi-barometer'></i>
          </ons-icon>
        </div>
          <strong>Pressure:</strong>&nbsp;
          #{ Math.round d.currently.pressure }&nbsp;hPa
      </ons-list-item>
    """
    list.append item

    # cloud cover
    item = ons.createElement """
      <ons-list-item class='open-sans'>
        <div class="left">
          <ons-icon class="list-item__icon">
            <i class='wi wi-day-cloudy-high'></i>
          </ons-icon>
        </div>
          <strong>Cloud cover:</strong>&nbsp;
          #{ Math.round d.currently.cloudCover*100 }%
      </ons-list-item>
    """
    list.append item

    # visibility
    item = ons.createElement """
      <ons-list-item class='open-sans'>
        <div class="left">
          <ons-icon class="list-item__icon">
            <i class="far fa-eye"></i>
          </ons-icon>
        </div>
          <strong>Visibility:</strong>&nbsp;
          #{ d.currently.visibility }&nbsp;km
      </ons-list-item>
    """
    list.append item

    # precipitation
    item = ons.createElement """
      <ons-list-item class='open-sans'>
        <div class="left">
          <ons-icon class="list-item__icon">
            <i class='wi wi-raindrops'></i>
          </ons-icon>
        </div>
        <div class='center'>
          <strong>Precipitation:</strong>&nbsp;
          #{ Math.round d.currently.precipProbability*100 }%
        </div>
      </ons-list-item>
    """
    list.append item

    # wind returned is m/sec ~  60*60/1000 k/h
    item = ons.createElement """
      <ons-list-item class='open-sans'>
        <div class="left">
          <ons-icon class="list-item__icon">
            <i class='wi wi-strong-wind'></i>
          </ons-icon>
        </div>
        <div class='center'>
          <strong>Wind:</strong>&nbsp;
          #{  (3.6 * d.currently.windSpeed).toFixed(2) }&nbsp;km/h
        </div>
      </ons-list-item>
    """
    list.append item

    # wind bearing
    item = ons.createElement """
      <ons-list-item class='open-sans'>
        <div class="left">
          <ons-icon class="list-item__icon">
            <i class='wi wi-wind #{ windBearingIcon d.currently.windBearing }'></i>
          </ons-icon>
        </div>
        <div class='center'>
          <strong>Wind bearing:</strong>&nbsp;
          #{  d.currently.windBearing }&deg;
          <small>(0&deg;: north, clockwise)</small>
        </div>
      </ons-list-item>
    """
    list.append item

    # ozone
    item = ons.createElement """
      <ons-list-item class='open-sans'>
        <div class="left">
          <ons-icon class="list-item__icon">
            <i class="far fa-circle"></i><sub><small>3</small></sub>
          </ons-icon>
        </div>
        <div class='center'>
          <strong>Ozone:</strong>&nbsp;
          #{  Math.round d.currently.ozone }&nbsp;
          <small>(harmful: 100&ndash;315)</small>
        </div>
      </ons-list-item>
    """
    list.append item

    # uv idx
    item = ons.createElement """
      <ons-list-item class='open-sans'>
        <div class="left">
          <ons-icon icon="fa-sun" class="list-item__icon"></ons-icon>
        </div>
        <div class='center'>
          <strong>UV index:</strong>&nbsp;
          #{ d.currently.uvIndex }
        </div>
      </ons-list-item>
    """
    list.append item

    # sunrise
    item = ons.createElement """
      <ons-list-item class='open-sans'>
        <div class="left">
          <ons-icon class="list-item__icon">
            <i class="wi wi-sunrise"></i>
          </ons-icon>
        </div>
        <div class='center'>
          <strong>Sunrise:</strong>&nbsp;
          <small>#{ (new Date d.daily.data[0].sunriseTime*1000).toString()[16..23] }</small>
        </div>
      </ons-list-item>
    """
    list.append item

    # sunrise
    item = ons.createElement """
      <ons-list-item class='open-sans'>
        <div class="left">
          <ons-icon class="list-item__icon">
            <i class="wi wi-sunset"></i>
          </ons-icon>
        </div>
        <div classs='center'>
          <strong>Sunset:</strong>&nbsp;
          <small>#{ (new Date d.daily.data[0].sunsetTime*1000).toString()[16..23] }</small>
        </div>
      </ons-list-item>
    """
    list.append item

ons.ready () ->
  # cordova stuff
  fn.loadHome()
  unless cordova?
    ons.notification.toast "Cordova not loaded", timeout: 5000
