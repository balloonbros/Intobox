class AddCountryColumn < ActiveRecord::Migration
  def change
    add_column :dropbox_authenticates, :country, :string, limit: 2
  end
end
