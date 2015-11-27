class Game < ActiveRecord::Base
  has_one :round
  after_create :create_round
  validates :player1, presence: true, length: {maximum: 100}
  validates :player2, presence: true, length: {maximum: 100}
  validates :score_player1, numericality: { only_integer: true, greater_than_or_equal_to: 0}
  validates :score_player2, numericality: { only_integer: true, greater_than_or_equal_to: 0}
  validates :play_count, numericality: { only_integer: true, greater_than_or_equal_to: 0}

  validate :player_names_different


  def new_round
    round.start_new(play_count % 2 + 1)
    self.update(play_count: play_count + 1)
  end
  private
    def player_names_different
      if player1 == player2
        errors.add(:player2, "should be different than player1")
      end
    end
end
