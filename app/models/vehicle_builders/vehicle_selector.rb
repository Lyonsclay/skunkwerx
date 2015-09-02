class VehicleSelector
  def self.find(params)
    query= "SELECT * FROM years WHERE range=? AND engine_id IN (SELECT engines.id FROM engines WHERE id=?)"
    year = Year.find_by_sql([query, params[:select_vehicle][:year][:range], params[:select_vehicle][:engine][:id]]).first
    year.vehicle
  end
end
