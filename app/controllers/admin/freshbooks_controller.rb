require 'pry'
require 'net/https'
require 'uri'
# For parsing XML
require 'rexml/document'
# Import into the top level namespace for convenience
include REXML


class Admin::FreshbooksController < ApplicationController
  layout 'admin'

  def index
  end

  def items_sync
    # Make sure admin is signed in!
    if current_admin
      # Make initial call to determine number( num ) of pages
      xml_hash = Hash.from_xml freshbooks_call(message(1)).body
      num = xml_hash["response"]["items"]["pages"].to_i
      items = []
# binding.pry
      # Make a call for each page and add results to items array.
      (1..num).each do |page|
        response = freshbooks_call(message(page))
        xml_hash = Hash.from_xml response.body
        items += xml_hash["response"]["items"]["item"]
# binding.pry
      end

      items.each do |item|
        unless item["tax2_id"].nil?
          if item["name"].match("Malone")
            MaloneTune.create(item)
          else
            Product.create(item)
          end
        end
      end

    else
      #Response 400?
      #Flash error
    end
    redirect_to '/admin'

  end

  private

  def message(page)
    "<?xml version=\"1.0\" encoding=\"utf-8\"?>
        <request method=\"item.list\">
          <page>#{page}</page>
          <per_page>50</per_page>
          <folder>active</folder>
        </request>"
  end

  # Set the request URL
  def freshbooks_call(message)
    uri = URI.parse('https://skunkwerxperformanceautomotivellc.freshbooks.com/api/2.1/xml-in')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    # http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth '9060c77f9995a67283430a2fb07d35d1', 'X'
    request.body = message
    response = http.request(request)
    return response
  end

  def display_response(response)
    puts "body: #{response.body}"
    puts "code: #{response.code}"
    puts "message: #{response.message}"
    puts "class: #{response.class.name}"
  end
end
