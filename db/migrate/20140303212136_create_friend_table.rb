class CreateFriendTable < ActiveRecord::Migration
  def up
    create_table :facebook_friends do |t|
      t.integer :user_id
      t.integer :friend_user_id
      t.integer :facebook_authenticate_id
      t.string :facebook_id
      t.string :facebook_name
      t.timestamps
      t.index :user_id
      t.index :facebook_id
    end
  end
end
