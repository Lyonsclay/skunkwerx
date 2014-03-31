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
    if !current_admin
      redirect_to root_path
    end
  end

  def items_sync
    # Make sure admin is signed in!
    if current_admin
      # Make initial call to determine number( num ) of pages
      xml_hash = Hash.from_xml freshbooks_call(message(1)).body
      num = xml_hash["response"]["items"]["pages"].to_i
      items = []
      # Make a call for each page and add results to items array.
      (1..num).each do |page|
        response = freshbooks_call(message(page))
        xml_hash = Hash.from_xml response.body
        items += xml_hash["response"]["items"]["item"]
      end
      #Save items that have been flagged with a value in tax2_id
      items.each do |item|
        item.delete_if{ |k,v| k = "item_id" }
        unless item["tax2_id"].nil?
          if item["name"].match("Malone")
            MaloneTune.create(item)
          else
            Product.create(item)
          end
        end
      end

    else
      redirect_to root_path
    end
    flash[:notice] = "Products have been successfully synced"
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
    uri = URI.parse(ENV['FRESHBOOKS_URL'])
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    # http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth ENV['FRESHBOOKS_KEY'], 'X'
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
