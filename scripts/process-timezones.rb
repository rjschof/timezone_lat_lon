require 'benchmark'
require 'byebug'
require 'kdtree'
require 'oj'
require 'rgeo/shapefile'
require 'rgeo/geo_json'
require 'ruby-progressbar'

# -- Global variables
$timezone_data = []

# -- Helper methods
def find_containing_timezone(lat:, lon:)
  factory = RGeo::Geographic.simple_mercator_factory
  point = factory.point(lon, lat)
  return $timezone_data.find { |sd| sd[:geometry].contains?(point) }
end

def load_geojson(geojson_path)
  load_benchmark = Benchmark.measure do 
    file = File.open(geojson_path)
    content = file.read
    geojson_obj = Oj.load(content)
    features = RGeo::GeoJSON.decode(geojson_obj)
    features.each do |feature|
      attributes = feature.keys.map do |key|
        [key, feature[key]]
      end.to_h

      $timezone_data << {
        geometry: feature.geometry,
        attributes: attributes,
      }
    end
  end
  puts("Load Benchmark: #{load_benchmark}")
end

def load_shapefile(shapefile_path)
  load_benchmark = Benchmark.measure do 
    RGeo::Shapefile::Reader.open(shapefile_path) do |file|
      file.each do |record|
        progress.increment
        $timezone_data << {
          geometry: record.geometry,
          attributes: record.attributes
        }
      end
    end
  end
  puts("Load Benchmark: #{load_benchmark}")
end

def test_timezone_check(lat:, lon:)
  timezone = nil
  benchmark = Benchmark.measure do 
    timezone = find_containing_timezone(lat: lat, lon: lon)
  end
  timezone_attrs = timezone.nil? ? nil : timezone[:attributes]
  puts("Timezone for [#{lat}, #{lon}]: #{timezone_attrs || 'NOT_FOUND'} - #{benchmark}")
end

# -- Script processing
# load_shapefile('./data/timezones/shapefile/combined-shapefile.shp')
begin
  timezone_data = File.open(File.expand_path("../../data/time_zones.dump", __FILE__)).read
  $timezone_data = Marshal.load(timezone_data)
  puts('Loaded timezone data from from dumpfile.')
rescue => exception
  puts("Exception: #{exception.inspect}")
  load_geojson('./data/timezones/geojson/combined-3.json')
  File.open(File.expand_path("../../data/time_zones.dump", __FILE__),"w") do |f|
    f.write(Marshal.dump($timezone_data))
  end
  puts('Loaded timezone data from scratch.')
end

puts("---------- Testing ----------")
latlon_list = [
  { lat: 49.886505, lon: 25.167341   }, # Ukraine
  { lat: 35.852462, lon: 14.447913   }, # Malta
  { lat: 23.058549, lon: 84.893071   }, # India... Jharkhand
  { lat: 25.303352, lon: -156.278805 }, # Pacific Ocean .. Near Hawaii
]
latlon_list.each do |latlon|
  test_timezone_check(latlon)
end