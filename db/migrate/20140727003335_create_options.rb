class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      # Copy columns from MaloneTune
      MaloneTune.columns.each do |column|
        next if column.name == "id"   # already created by create_table
        t.send(column.type, column.name.to_sym,  :null => column.null,:limit => column.limit, :default => column.default, :scale => column.scale, :precision => column.precision)
      end
    end
  end
end
