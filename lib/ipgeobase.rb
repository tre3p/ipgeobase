# frozen_string_literal: true

require_relative "ipgeobase/version"
require "http"
require "happymapper"

module Ipgeobase
  @ip_api_template = "http://ip-api.com/xml/"
  class << self
    def lookup(address)
      ip_api_xml_result = make_ip_api_request(address)
      parse_xml_to_ip_api_result(ip_api_xml_result)
    end

    private

    def make_ip_api_request(address)
      HTTP.get(@ip_api_template + address).to_s
    end

    def parse_xml_to_ip_api_result(req_result)
      result = HappyMapper.parse(req_result)
      IpApiResult.new({
        city: result.city,
        country: result.country,
        country_code: result.country_code,
        lat: result.lat,
        lon: result.lon
                      })
    end
  end

  class IpApiResult
    attr_reader :city, :country, :country_code, :lat, :lon

    def initialize(params)
      @city = params[:city]
      @country = params[:country]
      @country_code = params[:country_code]
      @lat = params[:lat]
      @lon = params[:lon]
    end
  end
end
