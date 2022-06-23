# frozen_string_literal: true

require_relative "test_helper"
require "ipgeobase"

class TestIpgeobase < Minitest::Test
  def setup
    @response_ip_api = '<query>
    <status>success</status>
    <country>Russia</country>
    <countryCode>RU</countryCode>
    <region>SVE</region>
    <regionName>Sverdlovsk Oblast</regionName>
    <city>Yekaterinburg</city>
    <zip>620010</zip>
    <lat>56.8439</lat>
    <lon>60.6524</lon>
    <timezone>Asia/Yekaterinburg</timezone>
    <isp>PJSC MegaFon</isp>
    <org>OJSC MegaFon GPRS/UMTS Network</org>
    <as>AS31224 PJSC MegaFon</as>
    <query>83.169.216.199</query>
    </query>'
    @expected = HappyMapper.parse(@response_ip_api)
    stub_request(:get, "http://ip-api.com/xml/83.169.216.199").to_return(body: @response_ip_api)
  end

  def test_module_return_correct_data
    result = Ipgeobase.lookup("83.169.216.199")
    assert result.city == @expected.city
    assert result.country == @expected.country
    assert result.country_code == @expected.country_code
    assert result.lat == @expected.lat
    assert result.lon == @expected.lon
  end
end
