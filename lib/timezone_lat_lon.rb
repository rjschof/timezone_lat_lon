require 'timezone_lat_lon/loader'
require 'timezone_lat_lon/search'

module TimezoneLatLon
  class << self
    include Search

    @@loader = TimezoneLatLon::Loader.new(geojson_filename: 'combined-compressed.json')

    def loader
      return @@loader
    end
  end
end

