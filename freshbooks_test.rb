#!/Users/clay/.rvm/rubies/ruby-2.1.0/bin/ruby
require 'pry'
require 'net/https'
require 'uri'

# XML messages to Freshbooks api.
# Test without comment characters ie. "!-- --"

item_list_get =
  '<!--?xml version="1.0" encoding="utf-8"?-->
    <request method="item.list">
    </request>'

item_create =
  '<?xml version="1.0" encoding="utf-8"?>
  <request method="item.create">
    <item>
      <name>Fuzzy Slippers</name>
      <description>Extra soft</description>   <!-- (Optional) -->
      <unit_cost>59.99</unit_cost>            <!-- (Optional) -->
      <quantity>1</quantity>                  <!-- (Optional) -->
      <inventory>10</inventory>               <!-- By default, inventory is not tracked (Optional) -->
    </item>
  </request>'

item_update =
  '<?xml version="1.0" encoding="utf-8"?>
  <request method="item.update">
    <item>
      <item_id>68031</item_id>

      <inventory></inventory>                 <!-- Blank value disables inventory (Optional) -->
    </item>
  </request>'

item_delete =
  '<?xml version="1.0" encoding="utf-8"?>
  <request method="item.delete">
    <item_id>68031</item_id>
  </request>'

client_get =
  '<?xml version="1.0" encoding="utf-8"?>
  <request method="client.get">
    <client_id>28</client_id>
  </request>
  '

client_create =
  '<?xml version="1.0" encoding="utf-8"?>
  <request method="client.create">
    <client>
      <first_name>Jane</first_name>
      <last_name>Doe</last_name>
      <organization>ABC Corp</organization>
      <email>lyonsclay@yahoo.com</email>
      <!-- Defaults to first name + last name (Optional) -->
      <username>janedoe</username>
      <!-- Defaults to random password (Optional) -->
      <password>seCret!7</password>

    <!-- (Optional) -->
      <work_phone>(555) 123-4567</work_phone>
      <!-- (Optional) -->
      <home_phone>(555) 234-5678</home_phone>
      <!-- (Optional) -->
      <mobile></mobile>
      <!-- (Optional) -->
      <fax></fax>
      <!-- See language.list for codes. (Optional) -->
      <language>en</language>
      <!-- (Optional) -->
      <currency_code>USD</currency_code>
      <!-- (Optional) -->
      <notes>Drives a big car with a mariachi horn blast.</notes>

      <!-- Primary address (All optional) -->
      <p_street1>123 Fake St.</p_street1>
      <p_street2>Unit 555</p_street2>
      <p_city>New York</p_city>
      <p_state>New York</p_state>
      <p_country>United States</p_country>
      <p_code>553132</p_code>

      <!-- Secondary address (All optional) -->
      <s_street1></s_street1>
      <s_street2></s_street2>
      <s_city></s_city>
      <s_state></s_state>
      <s_country></s_country>
      <s_code></s_code>
      <!-- e.g. "VAT Number" (Optional) -->
      <vat_name></vat_name>
      <!-- If set, shown with vat_name under client address (Optional) -->
      <vat_number></vat_number>
    </client>
  </request>'

client_update =
  '<?xml version="1.0" encoding="utf-8"?>
<request method="client.update">
  <client>
    <client_id>172846</client_id>

    <!-- Same params as client.create -->
    <notes>Drives a big car with a mariachi horn blast.
    Also has Gilapi.</notes>

  </client>
</request>
'

client_delete =
  '<?xml version="1.0" encoding="utf-8"?>
<request method="client.delete">
  <client_id>172846</client_id>
</request>'


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










binding.pry
# p response.body
# puts "******************************************************"
# puts "******************************************************"
# p response.methods





