require 'pry'
require 'nokogiri'
require 'open-uri'

module Admin::MaloneTunesHelper
  # Base url
  @@base = ENV['MALONE_TUNING_URL']

  def vehicle_models
    # Build array of models with a hash of attributes.
    # { make: "", model: "", href: "" }
    models = [] # keys: :make :model :href

    # Get a Nokogiri::HTML::Document for page.
    doc =  Nokogiri::HTML(open(@@base))
    # Define Nokogiri::XML::NodeSet
    node_set = doc.xpath('//li[.//a[@href = "/ecu-tuning"]]/ul/li')
    node_set.each do |node|
# binding.pry
      # Case where auto make has just one tune.
      if node.css("ul").empty?
        models << { make: node.text,
          href: node.child[:href] }

      # Case where auto make has many models with their own
      #  models listed in a sub menu.
      elsif node.css("ul").first[:class] == "menu"
        node.css("a").each do |n|
    # binding.pry
          # Case where node href
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

  def model_tunes
    model_tunes = []
    doc = Nokogiri::HTML(open(@@base + params[:model][:href]))
    tunes = doc.css("div.view.view-engine").last.css("div.views-row")
# binding.pry
    tunes.each do |tune|
      tune_attributes = { name: tune.css('div.views-field.views-field-field-stage-tunes-title p').first.text }
      tune_attributes.update(description: tune.css('div.views-field-field-stage-description p').text)
      tune_attributes.update(price: find_price(doc, tune_attributes[:name]))
      unless tune.css('a').first.nil?
        tune_attributes.update(graph_url: tune.css("div.views-field.views-field.views-field-field-stage-dyno-chart a").first["href"])
      end
      tune_attributes.update(requires: requires_urls(tune))
      tune_attributes.update(recommended: recommended_urls(tune))
      model_tunes << tune_attributes
# binding.pry
    end
    model_tunes
  end

  def find_price(doc, name)
    prices = doc.css("table.views-table.cols-5 tbody tr")
    prices.each do |price|
      price_name = price.css("td.views-field-field-collection-tune p").text
      if /#{price_name}/.match name
        return price.css(".views-field-field-collection-price-cad-").text.strip
      end
    end
    return "Can't find price"
  end

  def requires_urls(tune)
    tune.css("div.views-field.views-field-field-stage-requires-1 img").map { |t| t["src"] }
  end
  def recommended_urls(tune)
    tune.css("div.views-field.views-field-field-stage-recommended-1 img").map { |t| t["src"] }
  end
end