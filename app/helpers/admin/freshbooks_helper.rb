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

  def callback_delete_message(callback_id)
    "<?xml version=\"1.0\" encoding=\"utf-8\"?>
      <request method=\"callback.delete\">
        <callback_id>#{callback_id}</callback_id>
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

  # Specifying event seems to fail, so it is left out.
  # <event>\"#{callback}\"</event>
  def callback_list_message
    "<?xml version=\"1.0\" encoding=\"utf-8\"?>
      <request method=\"callback.list\">
      </request>"
  end

  def item_create_message(tune)
    # Assign default quantity and inventory.
    "<?xml version=\"1.0\" encoding=\"utf-8\"?><request method=\"item.create\"><item><name>#{tune.name}</name><description>#{tune.description}</description><unit_cost>#{tune.unit_cost}</unit_cost><quantity>1</quantity><tax2_id>17823</tax2_id></item></request>"
  end

  def item_delete_message(item_id)
    "<?xml version=\"1.0\" encoding=\"utf-8\"?><request method=\"item.delete\"><item_id>#{item_id}</item_id></request>"
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
    # Strip unused attributes 'updated' and 'folder' from items.
    items.map { |item| item.except *["updated", "folder"] }
  end

  # Callback create request
  def callback_create(event)
    puts "**************** inside callback_create **************"
    response_hash = freshbooks_call(callback_create_message(event))
    puts "response_hash: " + response_hash.inspect
    callback_id = response_hash['response']['callback_id']
    flash[:notice] = display_response(response_hash)
    puts "******************************************************"
  end

  # Callback verify method
  def callback_verify(verifier)
    puts "**************** inside callback_verify *************"
    callback_id = params["object_id"]
    puts "***callback_id: " + callback_id.to_s
    response_hash = freshbooks_call(callback_verify_message(callback_id, verifier))
    flash[:notice] = display_response(response_hash)
    puts "*****************************************************"
  end

  # Method to retrieve callback_id from Freshbooks api. This is necessary if
  # callback request was made from a server other than the one hosting
  # skunkwerx-performance.com. This is also useful in the case that Rails.cache
  # fails.
  def callback_id_retrieve
    puts "****************** inside callback_id_retrieve ************"
    # Find the callback_id of the most recent callback.
    doc = Document.new callbacks_display.to_xml
    callback_ids = REXML::XPath.match(doc, '//callback-id')
    callback_ids.first.text
    puts "*****************************************************"
  end


  def delete_all_webhooks
    callback_list = freshbooks_call(callback_list_message)
    doc = Document.new callback_list.to_xml
    callback_list.each do |callback|
      callback_ids = REXML::XPath.match( doc, '//callback-id')
      callback_ids.map { |e| e.text.to_i }.each do |id|
        response_hash = freshbooks_call(callback_delete_message(id))
      end
    end
  end

  # Compare Freshbooks items and Skunkwerx web products
  # in order to identify discrepancies which indicate
  # webhooks are not performing correctly.
  def check_items_against_products(product_items, new_products)
    message = ""
    if new_products.any?
      message = "The following products were newly created; " + new_products.inspect
    end
    if product_items.count != Product.count
      message += "\nBefore syncing with Freshbooks, "
      message += "there were #{product_items.count} Freshbooks items and #{Product.count} web products"
    end
    message
  end

  # This routine retrieves item's attributes stripping the unused.
  def item_get(item_id)
    puts "****************** inside item_get ********************"
    item_hash = freshbooks_call(item_get_message(item_id))['response']['item']
    puts "***item_hash: " + item_hash.inspect
    puts "************ item_get send item_hash stripped **********"
    item_hash.except *["updated", "folder"]
  end

  # Receive item.create request and get product attributes.
  def item_create(item_id)
    puts "**************** inside item_create ****************"
    puts "******************* params *************************"
    puts "***" + params.inspect
    puts "****************************************************"
    item_hash = item_get(item_id)
    puts "************* return to item_create ****************"
    puts "***item_hash: " + item_hash.inspect
    puts "****************************************************"
    unless item_hash['tax2_id'].nil?
      if item_hash['name'].match("Malone")
        MaloneTuning.create(item_hash)
      else
        Product.create(item_hash)
      end
    end
    puts "*****************************************************"
  end

  def item_delete(item_id)
    puts "*************** inside item_delete ******************"
    product = Product.find_by item_id: item_id
    product.delete if product
    tune = MaloneTuning.find_by item_id: item_id
    puts "***Product.last: " + Product.last.inspect
    tune.delete if tune
    puts "****************************************************"
  end

  def item_update(item_id)
    puts "**************** inside item_update *****************"
    item = Product.find_by item_id: item_id
    item ||= MaloneTuning.find_by item_id: item_id
    puts "***item: " + item.inspect
    item_hash = item_get(item_id)
    puts "***item_hash: " + item_hash.inspect
    unless item_hash['tax2_id'].nil?
      item.update_attributes(item_hash)
    end
    puts "***errors: " + item.errors.to_s
    puts "*****************************************************"
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

  def callbacks_display
    display_response(freshbooks_call(callback_list_message))
  end

  def display_response(response_hash)
    puts "*********** from display_response ***********"
    puts "**************** response_hash **************"
    puts response_hash
    puts "*********************************************"
    response_hash
  end

  # Manualy synchronize Freshbooks Items with Skunkwerx Products and
  # Malone Tunes.
  def freshbooks_sync
    items = get_items
    # malone_tunings_items = []
    product_items = []
    # Track newly created items for sync descrepancy assesment.
    new_products = []
    # Split items into malone_tunings and products then save
    # to database.
    items.each do |item|
      if item["name"].match("Malone")
        # malone_tunings_items += item
        MaloneTuning.create(item)
      else
        product_items << item
        p = Product.create(item)
        if p.save
          new_products << p
        end
      end
    end
    flash[:sync_discrepancy] = check_items_against_products(product_items, new_products)
    # Fail-safe if item.delete callback doesn't work.
    if Product.count > product_items.count
      puts "************ item.delete callback failed *****************"
      puts "********* freshbooks_controller-spec.rb line 275 *********"
      dead_products_delete(product_items)
    end
    if flash[:sync_discrepancy].empty?
      flash[:notice] = "Products are up to date"
    end
  end

  #####################################################
  # ## Support methods that don't make api call; ######
  #
  # Perform two tests comparing Freshbooks items and Products( web products)
  # in order to identify discrepancies which indicate webhooks are not
  # performing correctly.
  def check_items_against_products(product_items, new_products)
    message = ""
    if new_products.any?
      message = "The following products were newly created; " + new_products.inspect
    end
    if product_items.count != Product.count
      message += "\nBefore syncing with Freshbooks, "
      message += "there were #{product_items.count} Freshbooks items and #{Product.count} web products"
    end
    message
  end

  # If there are products on the Skunkwerx database that
  # are not on the Freshbooks database they will be removed.
  # This condition would result if webhooks failed.
  def dead_products_delete(items)
    puts "************ inside dead_products_delete ************"
    # List of item ids for Freshbooks items both Malone and Skunkwerx.
    items_ids = items.map { |i| i["item_id"].to_i }
    # Remove dead Products
    Product.where.not(item_id: items_ids).delete_all
    # Remove dead MaloneTunings
    MaloneTuning.where.not(item_id: items_ids).delete_all
    puts "*********************************************************************"
  end

  def tune_item_create(id)
    malone_tuning = MaloneTuning.find(id) if MaloneTuning.find(id)
    new_item = freshbooks_call(item_create_message(malone_tuning))
    # Receive item_id from Freshbooks.
    item_id = new_item["response"]["item_id"].to_i
    # Update malone_tuning item_id.
    # tax2_id is used to indicate that an item is selected for web sales.
    malone_tuning.update_attributes(item_id: item_id)
    puts "********************** tune_item_create *****************************"
    puts "***new_item: #{new_item}"
    flash[:notice] = "#{malone_tuning.name} with item_id: #{item_id} created on Freshbooks database!"
    puts "*********************************************************************"
  end

  def tune_item_delete(item_id)
    puts "***************** tune_item_delete *************"
    flash[:notice] = freshbooks_call(item_delete(item_id))
    puts "***Response: #{flash[:notice]}"
  end
end

