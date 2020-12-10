require 'oj'
require 'rgeo/shapefile'
require 'rgeo/geo_json'

module TimezoneLatLon
  class Loader
    attr_accessor :config, :timezone_data

    CACHE_FILE_NAME = 'time_zones.cache'

    def initialize(config = {})
      @config = {
        geojson_filename: 'combined.json'
      }.merge(config)
      
      load_data
    end

    private

    def load_data
      timezone_dump_file  = File.expand_path(File.join('..', '..', 'data', CACHE_FILE_NAME), __dir__)
      if File.exists?(timezone_dump_file)
        @timezone_data = Marshal.load(File.open(timezone_dump_file).read)
      else # timezone_dump_file does not exist!
        self.load_data_from_geojson
      end
    end

    def load_data_from_geojson
      geojson_path = File.expand_path(File.join('..', '..', 'data', 'timezones', 'geojson', @config[:geojson_filename]), __dir__)
      content = File.open(geojson_path).read
      geojson_obj = Oj.load(content)
      features = RGeo::GeoJSON.decode(geojson_obj)
      @timezone_data = []
      features.each_with_index do |feature, index|
        attributes = feature.keys.map do |key|
          [key, feature[key]]
        end.to_h

        @timezone_data << {
          geometry: feature.geometry,
          attributes: attributes,
        }
      end

      timezone_dump_file = File.expand_path(File.join('..', '..', 'data', CACHE_FILE_NAME), __dir__)
      File.open(timezone_dump_file, "w") do |f|
        f.write(Marshal.dump(@timezone_data))
      end
    end
  end
end