// Generated by CoffeeScript 2.3.2

// daily.coffee: show daily forecast

var dailyNext, dailyPrev, moonPhaseIcon, renderDaily;

window.fn.loadDaily = function() {
  var content, menu;
  content = $('#content')[0];
  menu = $('#menu')[0];
  if (window.fn.selected === 'daily') {
    menu.close.bind(menu)();
    return;
  }
  return content.load('views/daily.html').then(menu.close.bind(menu)).then(function() {
    return renderDaily();
  });
};

moonPhaseIcon = function(v) { // v: 0..1
  v = Math.floor(28 * v);
  switch (false) {
    case v !== 0:
      return 'wi-moon-new';
    case !((0 < v && v < 7)):
      return `wi-moon-waxing-crescent-${v}`;
    case v !== 7:
      return 'wi-moon-first-quarter';
    case !((7 < v && v < 14)):
      return `wi-moon-waxing-gibbous-${v - 7}`;
    case v !== 14:
      return 'wi-moon-full';
    case !((14 < v && v < 21)):
      return `wi-moon-waning-gibbous-${v - 14}`;
    case v !== 21:
      return 'wi-moon-third-quarter';
    case !((21 < v && v < 28)):
      return `wi-moon-waning-crescent-${v - 21}`;
    default:
      return "wi-na";
  }
};

dailyPrev = function() {
  return $('#carousel')[0].prev();
};

dailyNext = function() {
  return $('#carousel')[0].next();
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
    var carousel, citem, dd, i, ref;
    console.log(d);
    window.fn.weather = d;
    carousel = $('#carousel')[0];
    ref = d.daily.data;
    // carousel.empty()
    for (i in ref) {
      dd = ref[i];
      citem = ons.createElement(`<ons-carousel-item>\n  <ons-card>\n    <div class='title'>\n      ${((new Date(dd.time * 1000)).toString().slice(0, 15))}\n      <i class='wi ${weatherIconFor(dd.icon)}'></i>\n    </div>\n    <div class='content'>\n      <ons-list>\n        <ons-list-item class='open-sans'>\n          <div class="left">\n            <ons-icon class="list-item__icon">\n              <i class='wi wi-thermometer'></i>\n            </ons-icon>\n          </div>\n          <div class='center'>\n            <strong>Temperature:</strong>&nbsp;\n              ${Math.round(dd.temperatureMin)}&deg;C /\n              ${Math.round(dd.temperatureMax)}&deg;C\n          </div>\n        </ons-list-item>\n        <ons-list-item class='open-sans' modifier='nodivider noborder'>\n          <div class="left">\n            <ons-icon class="list-item__icon">\n              <i class='wi ${weatherIconFor(dd.icon)}'></i>\n            </ons-icon>\n          </div>\n          <div class='center'>\n            <strong>Summary:</strong>&nbsp;\n            ${dd.summary}\n          </div>\n        </ons-list-item>\n        <ons-list-item class='open-sans' modifier='nodivider noborder'>\n          <div class="left">\n            <ons-icon class="list-item__icon">\n              <i class='wi wi-humidity'></i>\n            </ons-icon>\n          </div>\n          <div class='center'>\n            <strong>Humidity:</strong>&nbsp;\n            ${Math.round(dd.humidity * 100)}%\n          </div>\n        </ons-list-item>\n        <ons-list-item class='open-sans'>\n          <div class="left">\n            <ons-icon class="list-item__icon">\n              <i class='wi wi-barometer'></i>\n            </ons-icon>\n          </div>\n            <strong>Pressure:</strong>&nbsp;\n            ${Math.round(dd.pressure)}&nbsp;hPa\n        </ons-list-item>\n        <ons-list-item class='open-sans'>\n          <div class="left">\n            <ons-icon class="list-item__icon">\n              <i class='wi wi-day-cloudy-high'></i>\n            </ons-icon>\n          </div>\n            <strong>Cloud cover:</strong>&nbsp;\n            ${Math.round(dd.cloudCover * 100)}%\n        </ons-list-item>\n        <ons-list-item class='open-sans'>\n          <div class="left">\n            <ons-icon class="list-item__icon">\n              <i class="far fa-eye"></i>\n            </ons-icon>\n          </div>\n            <strong>Visibility:</strong>&nbsp;\n            ${dd.visibility}&nbsp;km\n        </ons-list-item>\n        <ons-list-item class='open-sans'>\n          <div class="left">\n            <ons-icon class="list-item__icon">\n              <i class='wi wi-raindrops'></i>\n            </ons-icon>\n          </div>\n          <div class='center'>\n            <strong>Precipitation:</strong>&nbsp;\n            ${Math.round(dd.precipProbability * 100)}%\n          </div>\n        </ons-list-item>\n        <ons-list-item class='open-sans'>\n          <div class="left">\n            <ons-icon class="list-item__icon">\n              <i class='wi wi-strong-wind'></i>\n            </ons-icon>\n          </div>\n          <div class='center'>\n            <strong>Wind:</strong>&nbsp;\n            ${(3.6 * dd.windSpeed).toFixed(2)}&nbsp;km/h\n            &nbsp;<i class='wi wi-wind ${windBearingIcon(dd.windBearing)}'></i>\n          </div>\n        </ons-list-item>\n        <ons-list-item class='open-sans'>\n          <div class="left">\n            <ons-icon icon="fa-sun" class="list-item__icon"></ons-icon>\n          </div>\n          <div class='center'>\n            <strong>UV index:</strong>&nbsp;\n            ${dd.uvIndex} /&nbsp;\n            <strong>Ozone:</strong>&nbsp;\n            ${Math.round(dd.ozone)}&nbsp;\n          </div>\n        </ons-list-item>\n        <ons-list-item class='open-sans' modifier='nodivider'>\n          <div class="left">\n            <ons-icon class="list-item__icon">\n              <i class="wi wi-sunrise"></i>\n            </ons-icon>\n          </div>\n          <div class='center'>\n            <strong>Sunrise/Sunset:</strong>&nbsp;\n            <small>${((new Date(dd.sunriseTime * 1000)).toString().slice(16, 24))}</small> /\n            <small>${((new Date(dd.sunsetTime * 1000)).toString().slice(16, 24))}</small>\n          </div>\n        </ons-list-item>\n        <ons-list-item class='open-sans' modifier='nodivider noborder'>\n          <div class="left">\n            <ons-icon class="list-item__icon">\n              <i class='wi ${moonPhaseIcon(dd.moonPhase)}'></i>\n            </ons-icon>\n          </div>\n          <div class='center'><strong>Moon phase:</strong>&nbsp;\n          ${Math.floor(dd.moonPhase * 28)}\n          </div>\n        </ons-list-item>\n      </ons-list>\n    </div>\n  </ons-card>\n</ons-carousel-item>`);
      carousel.appendChild(citem);
    }
    return carousel.refresh();
  });
};
