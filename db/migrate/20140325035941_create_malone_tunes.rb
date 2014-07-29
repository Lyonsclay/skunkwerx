class CreateMaloneTunes < ActiveRecord::Migration
  def self.up
    create_table :malone_tunes do |t|
      # Copy columns from Product
      Product.columns.each do |column|
        next if column.name == "id"   # already created by create_table
        t.send(column.type, column.name.to_sym,  :null => column.null,:limit => column.limit, :default => column.default, :scale => column.scale, :precision => column.precision)
      end
    end
  end

  def self.down
    drop_table :malone_tunes
  end

end
