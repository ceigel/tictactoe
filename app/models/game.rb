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

class Game < ActiveRecord::Base
  has_one :round
  after_create :create_round
  validates :player1, presence: true, length: {maximum: 100}
  validates :player2, presence: true, length: {maximum: 100}
  validates :score_player1, numericality: { only_integer: true, greater_than_or_equal_to: 0}
  validates :score_player2, numericality: { only_integer: true, greater_than_or_equal_to: 0}
  validates :play_count, numericality: { only_integer: true, greater_than_or_equal_to: 0}

  validate :player_names_different


  def register_round_finished
    update_scores
    self.update(score_player1: score_player1, score_player2: score_player2)
  end

  def player_name(player_number)
    player_number == 1 ? player1 : player2
  end

  def next_round
    self.update(play_count: play_count + 1)
    round.start_new(play_count % 2 + 1)
  end

  private
    def update_scores
      unless round.winner.nil?
        if round.winner == 1
          self.score_player1 += 1
        else
          self.score_player2 += 1
        end
      end
    end

    def player_names_different
      if player1 == player2
        errors.add(:player2, "should be different than player1")
      end
    end
end
