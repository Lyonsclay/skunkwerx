module Admin::MaloneTunesHelper
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

  def delete_engine_tunes(malone_tune)
    if params[:engine_tunes_delete]
      params[:engine_tunes_delete].each { |id| malone_tune.engine_tunes.find(id.to_i).delete }
    end
  end
end
