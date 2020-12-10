describe 'TimezoneLatLon' do
  latlon1 = { lat: 49.886505, lon: 25.167341   } # Ukraine
  latlon2 = { lat: 35.852462, lon: 14.447913   } # Malta
  latlon3 = { lat: 25.303352, lon: -156.278805 } # Pacific Ocean

  # -- Test storing/loading time_zones.cache after initialization
  describe 'cache file' do
    CACHE_FILE = './data/time_zones.cache'

    before :example do
      cache_exists = File.exists?(CACHE_FILE)
      File.delete(CACHE_FILE) if cache_exists

      require 'timezone_lat_lon'
    end

    context 'on first run' do
      it 'is created' do
        TimezoneLatLon.find_timezone(latlon3)
        cache_exists_after = File.exists?(CACHE_FILE)
        expect(cache_exists_after).to eql(true)
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