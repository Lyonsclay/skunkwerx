require 'nokogiri'

class VehicleModels
  # Build array of models with a hash of attributes.
  # { make: "", model: "", href: "" }
  def self.get
    models = []
    # Get a Nokogiri::HTML::Document for page.
    doc =  Nokogiri::HTML(open(BASE, read_timeout: 120))
    # Define Nokogiri::XML::NodeSet
    node_set = doc.xpath('//li[.//a[@href = "/ecu-tuning"]]/ul/li')
    node_set.each do |node|
      # Case where auto make has just one tune.
      if node.css("ul").empty?
        models << { make: node.text, href: node.child[:href] }
      # Case where auto make has many models with their own
      #  models listed in a sub menu.
      elsif node.css("ul").first[:class] == "menu"
        node.css("a").each do |n|
          # Case where node href
          # indicated by right pointing double angle.
          unless n.text.bytes.include? 187
            models << { model: n.child.text,
              make: node.child.child.text,
              href: n[:href] }
          end
        end
      end
    end
    models
  end
end
