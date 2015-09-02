require 'nokogiri'

class VehicleTunings
  # Array of malone_tuning_builders with relevant attributes for a particular vehicle.
  def vehicle_tunings
    # Delete all MaloneTuningBuilder to reset @make_model
    MaloneTuningBuilder.delete_all
    malone_tuning_builders = []
    # Load document with all tunes for particular model vehicle.
    doc = Nokogiri::HTML(open(BASE + params[:model][:href]))
    # Get each tune's specs from top table with all tunes for
    # that model.
    doc.css('div.view-content tbody tr').each do |tune|
      tune_attributes = { make: params[:model][:make] }
      tune_attributes[:model] = params[:model][:model]
      tune_attributes[:engine] = tune.css('.views-field-field-engine').text.strip
      tune_attributes[:engine] = tune.css('.views-field-field-collection-engine').text.strip
      tune_attributes[:name] = tune.css('.views-field-field-new-collection-tune').text.strip
      tune_attributes[:name] = tune.css('.views-field-field-collection-tune').text.strip
      tune_attributes[:power] = tune.css('.views-field-field-collection-power').text.strip
      tune_attributes[:unit_cost] = tune.css('.views-field-field-collection-price-cad-').text.strip
      tune_attributes[:standalone_price] = tune.css('.views-field-field-price').text.strip
      tune_attributes[:price_with_purchase] = tune.css('.views-field-field-price-with-tune-purchase').text.strip
      malone_tuning_builders << tune_match_or_create(tune_attributes)
    end

    # Get additional attributes from main content including image URLs.
    # First check for presence of main content entries.
    tunes_details = doc.css('.view-engine').last.css('div.views-row')
    unless tunes_details.first.children[1].text.strip.empty?
      tunes_details.each do |tune|
        tune_name = tune.children[1].text.strip
        tuning = tune_match_or_create({name: tune_name})
        # tuning.update_attribute(:name, tune_name)  # is this necessary?
        tuning.description = tune.css('div.views-field-field-stage-description p').text 
        unless tune.css('a').first.nil?
          tuning.graph_url = tune.css('div.views-field.views-field.views-field-field-stage-dyno-chart a').first['href']
        end
        # Create new MaloneTuningBuilder from tune_attributes
        # Due to the way Postgresql and ActiveRecord process array columns
        # tuning cannot be created with array columns, but must be updated
        tuning.update_attributes(requires_urls: requires_urls(tune), recommended_urls: recommended_urls(tune) )
        malone_tuning_builders << tuning
      end
    end

    malone_tuning_builders.uniq
    session[:malone_tuning_builders] = malone_tuning_builders.map { |t| t  }

    # Strip description from name and add 'Malone -' + tuning + make/model
    malone_tuning_builders.each do |tuning|
      # #partition splits string into before, match, and after of regex capture.
      name_parts = tuning.name.partition /^(\w+\.?\w?\s?){1,2}/
      tuning.name = 'Malone - ' + name_parts[1] + ' ' + tuning.make.to_s + '/' + tuning.model.to_s
      tuning.description ||= ''
      tuning.description += name_parts[2] if name_parts[2][0]    # ""[0] == nil
      tuning.save
    end
    malone_tuning_builders
  end
end
