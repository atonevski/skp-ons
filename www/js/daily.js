// Generated by CoffeeScript 2.3.2

// daily.coffee: show daily forecast

var dailyNext, dailyPrev, renderDaily;

window.fn.loadDaily = function() {
  var content, menu;
  content = $('#content')[0];
  menu = $('#menu')[0];
  return content.load('views/daily.html').then(menu.close.bind(menu)).then(function() {
    return renderDaily();
  });
};

//   var carousel = document.addEventListener('postchange', function(event) {
//     console.log('Changed to ' + event.activeIndex)
//   });
dailyPrev = function() {
  console.log("Carousel prev");
  return $('ons-carousel#carousel').prev();
};

dailyNext = function() {
  console.log("Carousel next");
  return $('ons-carousel#carousel').next();
};

renderDaily = function() {
  var KEY, LAT, LNG, url;
  window.fn.selected = 'daily';
  KEY = '6376c1cdba2fa461f346e9a27524406d';
  LAT = 42;
  LNG = 21.43;
  url = `https://api.darksky.net/forecast/${KEY}/${LAT},${LNG}?units=si`;
  return $.ajax({
    url: url,
    method: 'GET'
  }).done(function(d) {
    var carousel, citem, dd, i, ref, results;
    console.log(d);
    window.fn.weather = d;
    carousel = $('#carousel');
    carousel.empty();
    ref = d.daily.data;
    results = [];
    for (i in ref) {
      dd = ref[i];
      console.log(`add carousel item ${i}`);
      citem = ons.createElement(`<ons-carousel-item>\n  <div style="text-align: center; font-size: 30px; margin-top: 20px;">\n    <br />\n    <p style='font-size: 90px'>${i}:</p>\n  </div>\n</ons-carousel-item>`);
      results.push(carousel.append(citem));
    }
    return results;
  });
};