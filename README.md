# TimezoneLatLon
The TimezoneLatLon gem allows users to search for the timezone contained by any latitude/longitude. 

This gem was inspired by the NearestTimeZone gem which is currently unmaintained. 

## Installation
### With Bundler
Add the following line to your `Gemfile`:
```
gem 'timezone_lat_lon'
```
### Manually
Run the following to install from Rubygems:
```
gem install timezone_lat_lon
```

## Usage
```ruby
require 'timezone_lat_lon'

timezone1 = TimezoneLatLon.find_timezone(lat: 49.886505, lon: 25.167341)
# => #<TZInfo::DataTimezone: Europe/Kiev> 

latlon2 = { lat: 35.852462, lon: 14.447913 }
timezone2 = TimezoneLatLon.find_timezone(latlon2)
# => #<TZInfo::DataTimezone: Europe/Malta>

# If the timezone for a lat/lon cannot be found, it will just return nil:
latlon_bad = { lat: 25.303352, lon: -156.278805 }
timezone_bad = TimezoneLatLon.find_timezone(latlon_bad)
# => nil 
```
