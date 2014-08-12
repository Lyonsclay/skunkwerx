require 'nokogiri'
require 'open-uri'

module Admin::MaloneTuningsHelper
  # Base url
  @@base = ENV['MALONE_TUNING_URL']

  def vehicle_models
    # Build array of models with a hash of attributes.
    # { make: "", model: "", href: "" }
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

  # This method gathers desired attributes for the various tuning
  # products that will be resold through the Skunkwerx website.
  def vehicle_tunings
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
      malone_tunings << MaloneTuning.find_or_create_by(tune_attributes)
    end
    # Get additional attributes from main content including image URLs.
    # First check for presence of main content entries.
    tunes_details = doc.css('.view-engine').last.css('div.views-row')
    unless tunes_details.first.children[1].text.strip.empty?
      tunes_details.each do |tune|
        tune_name = tune.children[1].text.strip
        # tune_name_regex = tune_name[0,12].gsub(" ", '\s?').gsub(/(\-|\*|\(|\)|\+)/, '[\+\-\*\(\)]')
        tune_name_regex = tune_name.delete(' ').match(/^(\w|\s|\.)+/).to_s.gsub("",'\s?')
        tuning = MaloneTuning.where("name ~* ?", tune_name_regex).first
        tuning ||= MaloneTuning.create(name: tune_name)
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

  # Get and augment params for tunes that have been selected.
  # Create MaloneTune for each selected tune from params.
  def new_malone_tunes_from_params
    # Find Malone tunes that have been selected with checkbox.
    @new_malone_tunes_ids = []
    keys = params.keys.select { |key| params[key] == "1" }
    keys.each do |key|
      # String is frozen must be duplicated with dup to operate on.
      tune_name = key.dup.sub(/^checkbox_/, '')
      tune = params["tune_#{tune_name}"]
      # Make sure only hash is being passed to dangerous eval method.
      if eval(tune).class == Hash
        tune = eval(tune)
        tune_notes = tune
        tune.slice! *[:name, :unit_cost, :description]
        malone_tune = tune.except *[:engine, :standalone_price, :price_with_purchase, :power]
        # Using a goofy preface to signify tunes that are created for
        # testing. This will be changed to "Malone" when live.
        goofy = "Goofy-" + SecureRandom.urlsafe_base64(nil, false)[1..5]
        tune[:name] = goofy + tune[:name]
        tune[:requires] = params["requires_#{tune_name}"]
        tune[:recommended] = params["recommended_#{tune_name}"]
        # Set quantity to default value of 1 to pass validations,
        # however, it's worth considering not using quantity for tunes.
        tune[:quantity] = 1
        # Must convert string representation of price to decimal.
        tune[:unit_cost] = price_to_decimal tune[:unit_cost]
        tune[:standalone_price] = price_to_decimal tune[:standalone_price]
        tune[:price_with_purchase] = price_to_decimal tune[:price_with_purchase]
        new_tune = MaloneTune.new(tune)
        # @new_malone_tunes_ids << new_tune.id if new_tune.persisted?
        puts "********************* new_tune.errors *************************"
        puts new_tune.errors.inspect
      end
    end
    @new_malone_tunes_ids
  end

  def price_to_decimal(price)
    price.sub(/^\$/, '')
  end

  # Functions for malone_tunes/update.
  def add_engine_from_list(malone_tune)
    # Check for selection of at least three attributes??
    if params[:add_from_list].count >= 3
      engine = Engine.find_by_sql(["SELECT * FROM engines WHERE engine=? AND model_id IN (SELECT models.id FROM models WHERE id=?)", params[:add_from_list][:engine], params[:add_from_list][:model][:id]]).first
      malone_tune.engines << engine
    end
  end

  def create_and_add_new_engine(malone_tune)
    vehicle = params[:add_vehicle]
    unless vehicle[:make].empty?
      make = Make.find_or_create_by(make: vehicle[:make])
      model = make.models.find_or_create_by(model: vehicle[:model])
      engine = model.engines.find_or_create_by(engine: vehicle[:engine])
      engine.years += (vehicle[:years][:start].to_i..vehicle[:years][:end].to_i).to_a
      engine.years.uniq!
      engine.save
      malone_tune.engines << engine
    end
  end

  def delete_engines(malone_tune)
    if params[:engine_delete]
      params[:engine_delete].each { |id| malone_tune.engines.find(id.to_i).delete }
    end
  end
end


