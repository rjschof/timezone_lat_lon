require_relative 'lib/timezone_lat_lon/version'

Gem::Specification.new do |s|
    s.name        = 'timezone_lat_lon'
    s.version     = TimezoneLatLon::VERSION
    s.date        = '2020-12-09'
    s.summary     = 'Find timezones by latitude and longitude.'
    s.description = 'Find timezones by latitude and longitude.'
    s.authors     = ['Robert J. Schofield']
    s.email       = 'rjschofield96@gmail.com'
    s.files       = Dir['lib/**/*.rb', 'data/**/**', 'scripts/**', 'LICENSE.md', 'README.md']
    s.homepage    = 'https://github.com/rjschof/timezone_lat_lon'
    s.license     = 'MIT'

    s.add_runtime_dependency('oj', '~> 3.4')
    s.add_runtime_dependency('rgeo', '~> 2.2')
    s.add_runtime_dependency('rgeo-geojson', '~> 2.1')
    s.add_runtime_dependency('rgeo-shapefile', '~> 3.0')
    s.add_runtime_dependency('tzinfo', '~> 2.0')

    s.add_development_dependency('byebug', '~> 11.1')
  end