// Generated by CoffeeScript 2.3.2
var mph2kmph, mps2kmph, renderHome;

window.fn = {};

window.fn.selected = 'home';

window.fn.open = function() {
  var menu;
  menu = $('#menu')[0];
  return menu.open();
};

window.fn.load = function(page) {
  var content, menu;
  content = $('#content')[0];
  menu = $('#menu')[0];
  return content.load(page).then(menu.close.bind(menu));
};

window.fn.loadHome = function() {
  var content, menu;
  content = $('#content')[0];
  menu = $('#menu')[0];
  return content.load('views/home.html').then(menu.close.bind(menu)).then(function() {
    return renderHome();
  });
};

// miles per hour to kilometers per hour
mph2kmph = function(m) {
  return m * 1.609344;
};

// meters per second to kilometers per hour
mps2kmph = function(m) {
  return 3600.0 * m / 1000;
};

renderHome = function() {
  var KEY, LAT, LNG, url;
  window.fn.selected = 'home';
  KEY = '6376c1cdba2fa461f346e9a27524406d';
  LAT = 42;
  LNG = 21.43;
  url = `https://api.darksky.net/forecast/${KEY}/${LAT},${LNG}?units=si`;
  return $.ajax({
    url: url,
    method: 'GET'
  }).done(function(d) {
    var item, list;
    // console.log d
    window.fn.weather = d;
    $('p#temp').html(`${Math.round(d.currently.temperature)}&deg;C`);
    list = $('ons-list#current-values');
    list.empty();
    // time
    item = ons.createElement(`<ons-list-item class='open-sans'>\n  <div class="left">\n    <ons-icon icon="ion-clock" class="list-item__icon"></ons-icon>\n  </div>\n  <div class='center'>\n    <strong>Time:</strong>&nbsp;\n    <small>\n      ${((new Date(d.currently.time * 1000)).toString().slice(0, 24))}&nbsp;\n      ${d.timezone}\n    </small>\n  </div>\n</ons-list-item>`);
    list.append(item);
    // summary
    item = ons.createElement(`<ons-list-item class='open-sans'>\n  <div class="left">\n    <ons-icon icon="fa-pencil-ruler" class="list-item__icon"></ons-icon>\n  </div>\n  <div class='center'>\n    <strong>Summary:</strong>&nbsp;\n    ${d.currently.summary}\n  </div>\n</ons-list-item>`);
    list.append(item);
    // apparent temp.
    item = ons.createElement(`<ons-list-item class='open-sans'>\n  <div class="left">\n    <ons-icon icon="fa-thermometer-half" class="list-item__icon"></ons-icon>\n  </div>\n  <div class='center'>\n    <strong>Apparent temp.:</strong>&nbsp;\n      ${Math.round(d.currently.humidity)}&degC;\n  </div>\n</ons-list-item>`);
    list.append(item);
    // humidity
    item = ons.createElement(`<ons-list-item class='open-sans'>\n  <div class="left">\n    <ons-icon icon="fa-tint" class="list-item__icon"></ons-icon>\n  </div>\n  <div class='center'>\n    <strong>Humidity:</strong>&nbsp;\n    ${Math.round(d.currently.humidity * 100)}%\n  </div>\n</ons-list-item>`);
    list.append(item);
    // pressure
    item = ons.createElement(`<ons-list-item class='open-sans'>\n  <div class="left">\n    <ons-icon icon="ion-hammer" class="list-item__icon"></ons-icon>\n  </div>\n    <strong>Pressure:</strong>&nbsp;\n    ${Math.round(d.currently.pressure)}&nbsp;hPa\n</ons-list-item>`);
    list.append(item);
    // cloud cover
    item = ons.createElement(`<ons-list-item class='open-sans'>\n  <div class="left">\n    <ons-icon icon="md-cloud" class="list-item__icon"></ons-icon>\n  </div>\n    <strong>Cloud cover:</strong>&nbsp;\n    ${Math.round(d.currently.cloudCover * 100)}%\n</ons-list-item>`);
    list.append(item);
    // precipitation
    item = ons.createElement(`<ons-list-item class='open-sans'>\n  <div class="left">\n    <ons-icon icon="fa-shower" class="list-item__icon"></ons-icon>\n  </div>\n  <div class='center'>\n    <strong>Precipitation:</strong>&nbsp;\n    ${Math.round(d.currently.precipProbability * 100)}%\n  </div>\n</ons-list-item>`);
    list.append(item);
    // wind
    item = ons.createElement(`<ons-list-item class='open-sans'>\n  <div class="left">\n    <ons-icon icon="fa-redo-alt" class="list-item__icon" spin></ons-icon>\n  </div>\n  <div class='center'>\n    <strong>Wind:</strong>&nbsp;\n    ${(mph2kmph(d.currently.windSpeed)).toFixed(2)}km/h\n  </div>\n</ons-list-item>`);
    list.append(item);
    // wind bearing
    item = ons.createElement(`<ons-list-item class='open-sans'>\n  <div class="left">\n    <ons-icon icon="fa-compass" class="list-item__icon"></ons-icon>\n  </div>\n  <div class='center'>\n    <strong>Wind bearing:</strong>&nbsp;\n    ${d.currently.windBearing}&deg;\n    <small>(0&deg;: north, clockwise)</small>\n  </div>\n</ons-list-item>`);
    list.append(item);
    // ozone
    item = ons.createElement(`<ons-list-item class='open-sans'>\n  <div class="left">\n    <ons-icon icon="fa-circle-notch" class="list-item__icon"></ons-icon>\n  </div>\n  <div class='center'>\n    <strong>Ozone:</strong>&nbsp;\n    ${Math.round(d.currently.ozone)}&nbsp;\n    <small>(harmful: 100&ndash;315)</small>\n  </div>\n</ons-list-item>`);
    list.append(item);
    // uv idx
    item = ons.createElement(`<ons-list-item class='open-sans'>\n  <div class="left">\n    <ons-icon icon="fa-sun" class="list-item__icon"></ons-icon>\n  </div>\n  <div class='center'>\n    <strong>UV index:</strong>&nbsp;\n    ${d.currently.uvIndex}\n  </div>\n</ons-list-item>`);
    list.append(item);
    // sunrise
    item = ons.createElement(`<ons-list-item class='open-sans'>\n  <div class="left">\n    <ons-icon icon="fa-arrow-up" class="list-item__icon"></ons-icon>\n  </div>\n  <div class='center'>\n    <strong>Sunrise:</strong>&nbsp;\n    <small>${((new Date(d.daily.data[0].sunriseTime * 1000)).toString().slice(16, 24))}</small>\n  </div>\n</ons-list-item>`);
    list.append(item);
    // sunrise
    item = ons.createElement(`<ons-list-item class='open-sans'>\n  <div class="left">\n    <ons-icon icon="fa-arrow-down" class="list-item__icon"></ons-icon>\n  </div>\n  <div classs='center'>\n    <strong>Sunset:</strong>&nbsp;\n    <small>${((new Date(d.daily.data[0].sunsetTime * 1000)).toString().slice(16, 24))}</small>\n  </div>\n</ons-list-item>`);
    return list.append(item);
  });
};

ons.ready(function() {
  // cordova stuff
  return fn.loadHome();
});
