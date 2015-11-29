# == Schema Information
#
# Table name: games
#
#  id            :integer          not null, primary key
#  player1       :string
#  player2       :string
#  score_player1 :integer          default(0)
#  score_player2 :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  play_count    :integer          default(0)
#

# Represents a match between two players.
# It has a single round which is reset when the respective round is finished (win/draw)
class Game < ActiveRecord::Base
  has_one :round
  after_create :create_round
  validates :player1, presence: true, length: {maximum: 100}
  validates :player2, presence: true, length: {maximum: 100}
  validates :score_player1, numericality: { only_integer: true, greater_than_or_equal_to: 0}
  validates :score_player2, numericality: { only_integer: true, greater_than_or_equal_to: 0}
  validates :play_count, numericality: { only_integer: true, greater_than_or_equal_to: 0}

  validate :player_names_different

  # Called by RoundsController when a round is finished
  # It resets round, and updates the score if a player won
  def register_round_finished
    update_scores
    self.update(score_player1: score_player1, score_player2: score_player2)
  end

  # Translate from player number to player name
  def player_name(player_number)
    player_number == 1 ? player1 : player2
  end

  # Called from RoundsController#create when the user clicks 'Next Round'
  # It updates play_count and resets the round
  def next_round
    self.update(play_count: play_count + 1)
    round.start_new(play_count % 2 + 1)
  end

  private
    # Update the score of the winner (if there is one)
    def update_scores
      unless round.winner.nil?
        if round.winner == 1
          self.score_player1 += 1
        else
          self.score_player2 += 1
        end
      end
    end

    # Validation for player's names different
    def player_names_different
      if player1 == player2
        errors.add(:player2, "should be different than player1")
      end
    end
end
