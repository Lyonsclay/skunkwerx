require 'net/https'
require 'uri'
# For parsing XML
require 'rexml/document'
# Import into the top level namespace for convenience
include REXML

module Admin::FreshbooksHelper
# ## Callback Response ##
# <?xml version="1.0" encoding="utf-8"?>
# <response xmlns="http://www.freshbooks.com/api/" status="ok">
# <callback_id>1</callback_id>
# </response>

# Verification information is sent to the callback URI.
# ## Headers ##
# POST /webhook HTTP/1.1
# Host: www.example.com
# Accept-Encoding: identity
# Content-Length: 130
# content-type: application/x-www-form-urlencoded
# user-agent: FreshHooks/0.4 (http://developers.freshbooks.com/api/webhooks)

# ## Body ##
# name=callback.verify&object_id=1&system=https%3A%2F%2F2ndsite.freshbooks.com&user_id=1&verifier=3bPTNcPgbN76QLgKLSR9XdgQJWvhhN4xrT


###############################################################
# ## Predefined messages to perform Freshbooks api requests; ##
  def item_list_message(page)
    "<?xml version=\"1.0\" encoding=\"utf-8\"?>
        <request method=\"item.list\">
          <page>#{page}</page>
          <per_page>50</per_page>
          <folder>active</folder>
        </request>"
  end

  def callback_create_message(event)
    "<?xml version=\"1.0\" encoding=\"utf-8\"?>
      <request method=\"callback.create\">
        <callback>
        <event>#{event}</event>
        <uri>http://www.skunkwerx-performance.com/webhooks</uri>
        </callback>
      </request>"
  end

  def callback_verify_message(callback_id, verifier)
    "<?xml version=\"1.0\" encoding=\"utf-8\"?>
      <request method=\"callback.verify\">
        <callback>
          <callback_id>#{callback_id}</callback_id>
          <verifier>#{verifier}</verifier>
        </callback>
      </request>"
  end

  def item_get_message(item_id)
    "<?xml version=\"1.0\" encoding=\"utf-8\"?>
      <request method=\"item.get\">
        <item_id>#{item_id}</item_id>
      </request>"
  end

  def callback_list_message(callback)
    "<?xml version=\"1.0\" encoding=\"utf-8\"?>
      <request method=\"callback.list\">
        <event>\"#{callback}\"</event>
        <uri>http://example.com/webhooks/ready</uri>
      </request>"
  end

  #####################################################
  # ## Methods that perform Freshbooks api requests; ##

  def get_items
    # Make initial call to determine number( num ) of pages
    response_hash = freshbooks_call(item_list_message(1))
    num = response_hash["response"]["items"]["pages"].to_i
    items = []
    # Make a call for each page and add results to items array.
    (1..num).each do |page|
      response_hash = freshbooks_call(item_list_message(page))
      items += response_hash["response"]["items"]["item"]
    end
    # Delete items that are not slated for web sales.
    items.delete_if {|item| item["tax2_id"].nil? }
    # Strip key "item_id" from item ( not a product attribute ).
    items.each do |item|
      item.delete_if {|k,v| k == "item_id" }
    end
    items
  end

  # Callback create request
  def callback_create(event)
    response_hash = freshbooks_call(callback_create_message(event))
    callback_id = response_hash['response']['callback_id']
    Rails.cache.write 'callback_id', callback_id
    flash[:notice] = display_response(response_hash)
  end

  # Callback verify method
  def callback_verify(verifier)
    puts "**************** inside callback.verify *************"
    callback_id = Rails.cache.read 'callback_id'
    puts "******************** callback_id ********************"
    puts callback_id
    puts "*****************************************************"
    response_hash = freshbooks_call(callback_verify_message(callback_id, verifier))
    flash[:notice] = display_response(response_hash)
  end

  # Perform two tests comparing Freshbooks items and Products( web products)
  # in order to identify discrepancies which indicate webhooks are not
  # performing correctly.
  def check_items_against_products(product_items, new_products)
    message = ""
    if new_products.any?
      message = "The following products were newly created; " + new_products.inspect
    end
    if product_items.count != Product.count
      message += "\nAfter syncing with Freshbooks, "
      message += "there are #{product_items.count} Freshbooks items and #{Product.count} web products"
    end
    message
  end

  # Receive item.create request and get product attributes.
  def item_create(object_id)
    puts "**************** inside item.create ****************"
    puts "******************* params *************************"
    puts params
    puts "****************************************************"
    response_hash = freshbooks_call(item_get_message(object_id))
    puts "*************** response_hash **********************"
    puts response_hash
    puts "****************************************************"
    Product.create(response_hash['response']['item'])
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
    Hash.from_xml response.body
  end

  def callbacks_display(callback)
    display_response(freshbooks_call(callback_list_message(callback)))
  end

  def display_response(response_hash)
    puts "**************** response_hash **************"
    puts response_hash
    puts "*********************************************"
    response_hash
  end

  def find_key(key)
    params.keys.detecdt {|k| k.match(/#{key}/) }
  end
end

