require 'timezone_lat_lon/loader'
require 'timezone_lat_lon/search'

module TimezoneLatLon
  class << self
    include Search

    def loader
      @@loader ||= create_loader
    end

    def reload_data
      @@loader = create_loader
    end
    
    private

    def create_loader
      TimezoneLatLon::Loader.new(geojson_filename: 'combined-compressed.json')
    end
  end
end

