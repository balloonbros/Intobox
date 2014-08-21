class InitializeDatabase < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :ip
      t.column :state, :tinyint
      t.column :deleted, :tinyint
      t.timestamps
    end

    create_table :facebook_authenticates do |t|
      t.integer :user_id
      t.string  :facebook_id
      t.string  :access_token
      t.string  :facebook_name
      t.string  :facebook_email
      t.column  :deleted, :tinyint
      t.timestamps
    end

    create_table :dropbox_authenticates do |t|
      t.integer :user_id
      t.string  :dropbox_id
      t.string  :access_token
      t.column  :deleted, :tinyint
      t.timestamps
    end

    create_table :transfer_histories do |t|
      t.integer :send_user_id
      t.integer :receive_user_id
      t.column  :state, :tinyint
      t.string  :filename
      t.string  :image
      t.column  :api_response, :text
      t.column  :deleted, :tinyint
      t.timestamps
    end
  end

  def down
  end
end
