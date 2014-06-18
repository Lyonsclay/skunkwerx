require 'spec_helper'
require 'net/https'
require 'uri'
# For parsing XML
require 'rexml/document'
# Import into the top level namespace for convenience
include REXML

module Features
  module WebhooksTestHelpers
    def skunkwerks_get_products(name)
      uri = URI.parse(ENV['SKUNKWERX_URL'] + '/products/index')
      http = Net::HTTP.new(uri.host, uri.port)
      puts "******************* Net::HTTP **********************"
      http.use_ssl = true
      # http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(uri.request_uri)
      # request.basic_auth ENV['FRESHBOOKS_KEY'], 'X'
      request.body = message
      response = http.request(request)
      Hash.from_xml response.body
    binding.pry
    end
  end
end
