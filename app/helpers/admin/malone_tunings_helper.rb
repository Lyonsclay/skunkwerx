require 'nokogiri'
require 'open-uri'

module Admin::MaloneTuningsHelper
  # Base url
  @@base = ENV['MALONE_TUNING_URL']

  # Build array of models with a hash of attributes.
  # { make: "", model: "", href: "" }
  def vehicle_models
    models = []
    # Get a Nokogiri::HTML::Document for page.
    doc =  Nokogiri::HTML(open(@@base, read_timeout: 120))
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

  # Gather desired attributes for the various tuning products
  # that will be sold through the Skunkwerx website.
  def vehicle_tunings
    MaloneTuning.delete_all
    malone_tunings = []
    # Load document with all tunes for particular model vehicle.
    doc = Nokogiri::HTML(open(@@base + params[:model][:href]))
    # Get each tune's specs from top table with all tunes for
    # that model.
    doc.css('div.view-content tbody tr').each do |tune|
      tune_attributes = { make: params[:model][:make], model: params[:model][:model]}
      tune_attributes.update(engine: malone_tunings.last.engine) unless malone_tunings.empty?
      unless tune.css('.views-field-field-engine').text.strip.empty?
        tune_attributes[:engine] = tune.css('.views-field-field-engine').text.strip
      end
      unless tune.css('.views-field-field-collection-engine').text.strip.empty?
        tune_attributes[:engine] = tune.css('.views-field-field-collection-engine').text.strip
      end
      tune_attributes.update(name: tune.css('.views-field-field-new-collection-tune').text.strip)
      if tune_attributes[:name].nil? or tune_attributes[:name].empty?
        tune_attributes[:name] = tune.css('.views-field-field-collection-tune').text.strip
      end
      tune_attributes.update(power: tune.css('.views-field-field-collection-power').text.strip)
      tune_attributes.update(unit_cost: tune.css('.views-field-field-collection-price-cad-').text.strip)
      tune_attributes.update(standalone_price: tune.css('.views-field-field-price').text.strip)
      tune_attributes.update(price_with_purchase: tune.css('.views-field-field-price-with-tune-purchase').text.strip)
      malone_tunings << tune_match_or_create(tune_attributes)
    end

    # Get additional attributes from main content including image URLs.
    # First check for presence of main content entries.
    tunes_details = doc.css('.view-engine').last.css('div.views-row')
    unless tunes_details.first.children[1].text.strip.empty?
      tunes_details.each do |tune|
        tune_name = tune.children[1].text.strip

        tuning = tune_match_or_create({name: tune_name})
        tuning.update_attribute(:name, tune_name)
        # { |a| tune_name =~ /#{a[:name]}/ } || {}
        # tune_attributes[:name] = tune.children[1].text.strip
        tuning.update_attribute(:description, tune.css('div.views-field-field-stage-description p').text)
        unless tune.css('a').first.nil?
          tuning.update_attribute(:graph_url, tune.css('div.views-field.views-field.views-field-field-stage-dyno-chart a').first['href'])
        end
        # Create new MaloneTuning from tune_attributes
        # tuning = MaloneTuning.find_or_create_by(tune_attributes)
        # Due to the way Postgresql and ActiveRecord process array columns
        # tuning cannot be created with array columns, but must be updated.
        tuning.update_attributes(requires_urls: requires_urls(tune), recommended_urls: recommended_urls(tune) )
        malone_tunings << tuning
      end
    end
    session[:malone_tunings] = malone_tunings.uniq.map { |t| t  }
    malone_tunings.uniq
  end

  # These graphics are no longer required.
  def requires_urls(tune)
    tune.css("div.views-field.views-field-field-stage-requires-1 img").map { |t| t["src"] }
  end

  # These graphics are no longer required.
  def recommended_urls(tune)
    tune.css("div.views-field.views-field-field-recommended-1 img").map { |t| t["src"] }
  end

  def price_to_decimal(price)
    price  ##.sub(/^\$/, '')
  end

  # Find a tune with a similiar name to prevent creating redundant tunes.
  # Strip tune_name of spaces and take only characters that match
  # a simple name as found in the tables at the top of the page.
  # Ex. 'Stage 0', 'Stage 1.5', 'Stage 5 Custom'
  # Finally a zero or more white space regex expression is inserted
  # between every remaining character. This will catch a name that
  # has a missing space like 'Stage 5Custom'.
  def tune_match_or_create(tune_attributes)
    tune_name_regex = tune_attributes[:name].delete(' ').match(/^(\w|\s|\.)+/).to_s.gsub("",'\s?')
    tuning = MaloneTuning.where("name ~* ?", tune_name_regex).first
    tuning ||= MaloneTuning.create(tune_attributes)
    tuning
  end

  def make_model_display(malone_tuning)
    # malone_tuning.model is nil in some cases
    # necessitating the to_s method.
    malone_tuning.make + " " + malone_tuning.model.to_s
  end
end
