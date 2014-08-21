class AddFilesizeColumn < ActiveRecord::Migration
  def change
    add_column :transfer_histories, :file_size, :integer, default: 0
  end
end
