window.fn = { }

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

renderHome = () ->
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
    $('p#temp').html "#{ Math.round d.currently.temperature }&deg;C"

    list = $('ons-list#current-values')
    list.empty()

    # time
    item = ons.createElement """
      <ons-list-item class='open-sans'>
        <div class="left">
          <ons-icon icon="ion-clock" class="list-item__icon"></ons-icon>
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
          <ons-icon icon="fa-pencil-ruler" class="list-item__icon"></ons-icon>
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
          <ons-icon icon="fa-thermometer-half" class="list-item__icon"></ons-icon>
        </div>
        <div class='center'>
          <strong>Apparent temp.:</strong>&nbsp;
            #{ Math.round d.currently.humidity }&degC;
        </div>
      </ons-list-item>
    """
    list.append item

    # humidity
    item = ons.createElement """
      <ons-list-item class='open-sans'>
        <div class="left">
          <ons-icon icon="fa-tint" class="list-item__icon"></ons-icon>
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
          <ons-icon icon="ion-hammer" class="list-item__icon"></ons-icon>
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
          <ons-icon icon="md-cloud" class="list-item__icon"></ons-icon>
        </div>
          <strong>Cloud cover:</strong>&nbsp;
          #{ Math.round d.currently.cloudCover*100 }%
      </ons-list-item>
    """
    list.append item

    # precipitation
    item = ons.createElement """
      <ons-list-item class='open-sans'>
        <div class="left">
          <ons-icon icon="fa-shower" class="list-item__icon"></ons-icon>
        </div>
        <div class='center'>
          <strong>Precipitation:</strong>&nbsp;
          #{ Math.round d.currently.precipProbability*100 }%
        </div>
      </ons-list-item>
    """
    list.append item

    # wind
    item = ons.createElement """
      <ons-list-item class='open-sans'>
        <div class="left">
          <ons-icon icon="fa-redo-alt" class="list-item__icon" spin></ons-icon>
        </div>
        <div class='center'>
          <strong>Wind:</strong>&nbsp;
          #{  (mph2kmph d.currently.windSpeed).toFixed(2) }km/h
        </div>
      </ons-list-item>
    """
    list.append item

    # wind bearing
    item = ons.createElement """
      <ons-list-item class='open-sans'>
        <div class="left">
          <ons-icon icon="fa-compass" class="list-item__icon"></ons-icon>
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
          <ons-icon icon="fa-circle-notch" class="list-item__icon"></ons-icon>
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
          <ons-icon icon="fa-arrow-up" class="list-item__icon"></ons-icon>
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
          <ons-icon icon="fa-arrow-down" class="list-item__icon"></ons-icon>
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


