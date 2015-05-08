# class AddDefaultToYears < ActiveRecord::Migration
#   def up
#     # Postgresql doesn't accept [] as a default value. '{}' is the
#     # equivalent.
#     change_column :engines, :years, :string, array: true, default: '{}'
#   end

#   def down
#     change_column :engines, :years, :string, array: true, default: nil
#   end
# end
