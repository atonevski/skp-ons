# skp-ons
*Skp-ons* is an onsenui demo app that reads [Skopje Pulse](https://skopjepulse.mk/) collected data. It also, shows current and daily weather forecast, maps with animated pollutant measurements and clouds.

## Installation
```
# compile coffee-script code
coffee -o www/js/ -wcb www/coffee/ 

# create icons for cordova
# install with: npm install cordova-icon -g
cordova-icon

# build the cordova/onsenui app
cordova platform add android
cordova build android
```

## Usage
![home](/www/img/scr-home-s.png?raw=true)
![sensors](/www/img/scr-sensors-s.png?raw=true)
![measurements](/www/img/scr-measurements-s.png?raw=true)
![clouds](/www/img/scr-clouds-s.png?raw=true)

## Contributors

- [[atonevski]](https://github.com/atonevski) [mailto](mailto://atonevski@gmail.com) Andreja Tonevski - creator, maintainer
