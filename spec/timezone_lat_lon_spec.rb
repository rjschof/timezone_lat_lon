require 'spec_helper'
require 'timezone_lat_lon'

describe 'TimezoneLatLon' do
  latlon1 = { lat: 49.886505, lon: 25.167341   } # Ukraine
  latlon2 = { lat: 35.852462, lon: 14.447913   } # Malta
  latlon3 = { lat: 25.303352, lon: -156.278805 } # Pacific Ocean

  # -- Test storing/loading time_zones.cache after initialization
  describe 'cache file' do
    CACHE_FILE = './data/time_zones.cache'

    context 'cache missing' do
      it 'is created' do
        cache_file = File.join('.', 'data', TimezoneLatLon::Loader::CACHE_FILE_NAME)
        cache_exists_initial = File.exists?(cache_file)
        File.delete(cache_file) if cache_exists_initial
        
        expect(File.exists?(cache_file)).to eql(false)
        TimezoneLatLon.find_timezone(latlon3)
        
        cache_exists_after = File.exists?(cache_file)
        expect(cache_exists_after).to eql(true)
      end
    end

    context 'cache exists' do
      it 'is loaded' do
        cache_file = File.join('.', 'data', TimezoneLatLon::Loader::CACHE_FILE_NAME)
        cache_exists = File.exists?(cache_file)
        TimezoneLatLon.reload_data
        expect(cache_exists).to eql(true)
      end
    end
  end

  # -- Test the find_timezone method
  describe '.find_timezone(lat:, lon:)' do
    before :context do
      require 'timezone_lat_lon'
    end

    context "given #{latlon1.inspect}" do
      it "returns Europe/Ukraine" do
        expect(TimezoneLatLon.find_timezone(latlon1)).to eql(TZInfo::Timezone.get('Europe/Kiev'))
      end
    end

    context "given #{latlon2}" do
      it "returns Europe/Malta" do
        expect(TimezoneLatLon.find_timezone(latlon2)).to eql(TZInfo::Timezone.get('Europe/Malta'))
      end
    end

    context "given #{latlon3}" do
      it "returns nil" do
        expect(TimezoneLatLon.find_timezone(latlon3)).to eql(nil)
      end
    end
  end
end