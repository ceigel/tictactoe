class Game < ActiveRecord::Base
  validates :player1, presence: true, length: {maximum: 100}
  validates :player2, presence: true, length: {maximum: 100}
  validates :score_player1, numericality: { only_integer: true, greater_than_or_equal_to: 0}
  validates :score_player2, numericality: { only_integer: true, greater_than_or_equal_to: 0}

  validate :player_names_different

  private
    def player_names_different
      if player1 == player2
        errors.add(:player2, "should be different than player1")
      end
    end
end
