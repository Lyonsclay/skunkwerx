require 'pry'
require 'nokogiri'
require 'open-uri'

# Get a Nokogiri::HTML::Document for page.
doc = Nokogiri::HTML(open("http://www.malonetuning.com/"  ))

# Do funky things with it using Nokogiri::XML::Node methods...

# binding.pry
####
#Search for nodes by xpath
d = doc.xpath('//li[.//a[@href = "/ecu-tuning"]]/ul/li/a')
binding.pry
