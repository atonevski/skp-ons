#
# daily.coffee: show daily forecast
#


window.fn.loadDaily = () ->
  content = $('#content')[0]
  menu = $('#menu')[0]

  content.load 'views/daily.html'
         .then menu.close.bind(menu)
         .then () -> renderDaily()


#   var carousel = document.addEventListener('postchange', function(event) {
#     console.log('Changed to ' + event.activeIndex)
#   });

dailyPrev = () ->
  console.log "Carousel prev"
  $('ons-carousel#carousel').prev()

dailyNext = () ->
  console.log "Carousel next"
  $('ons-carousel#carousel').next()

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

    carousel = $('#carousel')
    carousel.empty()

    for i, dd of d.daily.data
      console.log "add carousel item #{ i }"
      citem = ons.createElement """
        <ons-carousel-item>
          <div style="text-align: center; font-size: 30px; margin-top: 20px;">
            <br />
            <p style='font-size: 90px'>#{ i }:</p>
          </div>
        </ons-carousel-item>
      """
      carousel.append citem
