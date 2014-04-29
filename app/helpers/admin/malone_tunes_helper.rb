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

################################################################################
################################################################################
################################################################################
  def model_engine_tunes
    tunes = []
    # Load document with all tunes for particular model vehicle.
    doc = Nokogiri::HTML(open(@@base + params[:model][:href]))
    #####################################################################
    # Get each tune specs from table with all tunes for that model.
    doc.css('div.view-content tbody tr').each do |tune|
      tune_attributes = {}
      tune_attributes = { engine: tunes.last[:engine] } unless tunes.empty?
      unless tune.css('.views-field-field-engine').text.strip.empty?
        tune_attributes[:engine] = tune.css('.views-field-field-engine').text.strip
      end
      unless tune.css('.views-field-field-collection-engine').text.strip.empty?
        tune_attributes[:engine] = tune.css('.views-field-field-collection-engine').text.strip
      end
      tune_attributes.update(name: tune.css('.views-field-field-new-collection-tune').text.strip)
      if tune_attributes[:name].empty?
        tune_attributes[:name] = tune.css('.views-field-field-collection-tune').text.strip
      end
      tune_attributes.update(power: tune.css('.views-field-field-collection-power').text.strip)
      tune_attributes.update(price: tune.css('.views-field-field-collection-price-cad-').text.strip)
      tune_attributes.update(standalone_price: tune.css('.views-field-field-price'))
      tune_attributes.update(price_with_purchase: tune.css('.views-field-field-price-with-tune-purchase'))
      tunes << tune_attributes
    end
    #####################################################################
    # Get additional attributes including image URLs.
    tunes_details = doc.css('.view-engine').last.css('div.views-row')
    tunes_details.each do |tune|
      tune_name = tune.children[1].text.strip
      tune_attributes = tunes.find { |a| tune_name =~ /#{a[:name]}/ }
      tune_attributes[:name] = tune.children[1].text.strip
      tune_attributes.update(description: tune.css('div.views-field-field-stage-description p').text)
      unless tune.css('a').first.nil?
        tune_attributes.update(graph_url: tune.css('div.views-field.views-field.views-field-field-stage-dyno-chart a').first['href'])
      end
      tune_attributes.update(requires: requires_urls(tune))
      tune_attributes.update(recommended: recommended_urls(tune))
    end
    tunes
  end

  def requires_urls(tune)
    tune.css("div.views-field.views-field-field-stage-requires-1 img").map { |t| t["src"] }
  end

  def recommended_urls(tune)
    tune.css("div.views-field.views-field-field-recommended-1 img").map { |t| t["src"] }
  end
end