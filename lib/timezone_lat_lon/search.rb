require 'tzinfo'

module TimezoneLatLon
  module Search
    def find_timezone(lat: , lon:)
      factory = RGeo::Geographic.simple_mercator_factory
      point = factory.point(lon, lat)
      raw_timezone = TimezoneLatLon.loader.timezone_data.find { |sd| sd[:geometry].contains?(point) }
      return raw_timezone.nil? ? nil : TZInfo::Timezone.get(raw_timezone[:attributes]['tzid'])
    end
  end
end