class RenameServiceToName < ActiveRecord::Migration
  def self.up
    rename_column :locations, :service, :name
  end

  def self.down
    rename_column :locations, :name, :service
  end
end
