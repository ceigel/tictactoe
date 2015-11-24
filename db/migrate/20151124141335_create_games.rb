class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :player1, index: true
      t.string :player2, index: true
      t.integer :score_player1, default: 0
      t.integer :score_player2, default: 0

      t.timestamps null: false
    end
  end
end
