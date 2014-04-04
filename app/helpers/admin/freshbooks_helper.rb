module Admin::FreshbooksHelper
# Callback Response
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


  def initial_message(page)
    "<?xml version=\"1.0\" encoding=\"utf-8\"?>
        <request method=\"item.list\">
          <page>#{page}</page>
          <per_page>50</per_page>
          <folder>active</folder>
        </request>"
  end

  def callback_create_message(event)
    "<request method='callback.create'>
      <callback>
      <event>#{event}</event>
      <uri>http://www.skunkwerx-performance.com/callback_verify</uri>
      </callback>
    </request>"
  end

  def callback_verify_message(callback_id, verifier)
    "<request method='callback.verify'>
      <callback>
        <callback_id>#{callback_id}</callback_id>
        <verifier>#{verifier}</verifier>
      </callback>
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
    "body: #{response.body}" + "code: #{response.code}" + "message: #{response.message}" + "class: #{response.class.name}"
  end
end
