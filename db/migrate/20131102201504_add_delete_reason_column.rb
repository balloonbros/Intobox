class AddDeleteReasonColumn < ActiveRecord::Migration
  def change
    add_column :users, :delete_reason_type, :tinyint
    add_column :users, :delete_reason, :text
  end
end
