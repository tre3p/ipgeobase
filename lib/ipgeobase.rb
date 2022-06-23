# frozen_string_literal: true

require_relative "ipgeobase/version"
require 'http'
require 'happymapper'

module Ipgeobase
  @@IP_API_TEMPLATE = "http://ip-api.com/xml/"

  def self.lookup(address)
    ip_api_xml_result = make_ip_api_request(address)
    parse_xml_to_ip_api_result(ip_api_xml_result)
  end

  private 

  def self.make_ip_api_request(address)
    HTTP.get(@@IP_API_TEMPLATE + address).to_s
  end

  def self.parse_xml_to_ip_api_result(req_result)
    result = HappyMapper.parse(req_result)
    IpApiResult.new({
      city: result.city,
      country: result.country,
      countryCode: result.country_code,
      lat: result.lat,
      lon: result.lon
    })
  end

  class IpApiResult
    attr_reader :city, :country, :countryCode, :lat, :lon

    def initialize(params)
      @city = params[:city]
      @country = params[:country]
      @countryCode = params[:countryCode]
      @lat = params[:lat]
      @lon = params[:lon]
    end
  end
end
