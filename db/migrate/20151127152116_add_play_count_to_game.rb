class AddPlayCountToGame < ActiveRecord::Migration
  def change
    add_column :games, :play_count, :integer, default: 0
  end
end
