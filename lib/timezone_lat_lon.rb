require 'timezone_lat_lon/loader'
require 'timezone_lat_lon/search'

module TimezoneLatLon
  class << self
    include Search

    def loader
      @@loader ||= TimezoneLatLon::Loader.new(geojson_filename: 'combined-compressed.json')
    end
  end
end

