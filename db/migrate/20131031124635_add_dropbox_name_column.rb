class AddDropboxNameColumn < ActiveRecord::Migration
  def change
    add_column :dropbox_authenticates, :dropbox_name, :string
  end
end
