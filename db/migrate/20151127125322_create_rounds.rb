class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.string :board_state, limit: 9, default: '_' * 9
      t.belongs_to :game, index: true
      t.integer :current_player, default: 1

      t.timestamps null: false
    end
  end
end
