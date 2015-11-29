# == Schema Information
#
# Table name: rounds
#
#  id             :integer          not null, primary key
#  board_state    :string(9)        default("_________")
#  game_id        :integer
#  current_player :integer          default(1)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

# Represents a single round. 
# Keeps state in board_state field. Possible values 'X', '0', '_' (for empty cell)
class Round < ActiveRecord::Base
  belongs_to :game
  validates :current_player, numericality: { only_integer: true, greater_than_or_equal_to: 1}
  validates :current_player, numericality: { only_integer: true, less_than_or_equal_to: 2}

  # Reset the current round. Set current player to player passed as parameter
  def start_new(player)
    self.update(current_player: player, board_state: '_' * 9)
  end

  # Register move at row, column. The symbol used depends on the current player
  def make_move(row: , column: )
    symbol = current_symbol
    raise 'Round finished' if finished?
    raise 'Move already taken' if board(row: row, column: column) != '_'
    board_state[index_from_row_column(row, column)] = symbol
    self.update(board_state: board_state, current_player: next_player)
  end

  # Reads the field at row, column
  def board(row:, column:)
    board_state[index_from_row_column(row, column)]
  end

  # True if finished
  # Finished if a winner exists or if the board is completely filled.
  def finished?
    symbols_count = PLAYER_SYMBOLS.map{|s| board_state.count(s)}.inject(&:+)
    symbols_count == 9 || !winner.nil?
  end

  # The symbol used for the next move. It depends on current_player
  def current_symbol
    if current_player < 1 || current_player > 2
      raise "Impossible value for current_player #{current_player}"
    end
    return PLAYER_SYMBOLS[current_player - 1]
  end

  # returns player who won
  # or nil if no player won
  # make_move will refuse new moves if a winner exists, so it's impossible
  # to have more than one winner
  def winner
    row_winners = rows.select{|r| identical_symbols(r)}.map{|r| r[0]}
    column_winners = columns.select{|c| identical_symbols(c)}.map{|c| c[0]}
    diagonal_winners = diagonals.select{|d| identical_symbols(d)}.map{|d| d[0]}
    winners = (row_winners + column_winners + diagonal_winners).uniq - %w(_)
    players = winners.map{|w| to_player_number(w)}
    players[0] # this would default to nil if players is empty
  end

  private
    PLAYER_SYMBOLS = ["X", "0"]
    def index_from_row_column(row, column)
      row * 3 + column
    end

    # Separate board-state into rows.
    def rows
      3.times.map{|n| board_state[n * 3, 3]}
    end

    # Separate board-state into columns.
    def columns
      s = board_state
      3.times.map{|n| s[n] + s[n + 3] + s[n + 6]}
    end

    # Separate board-state into diagonals.
    def diagonals
      s = board_state
      first_diagonal = s[0] + s[4] + s[8]
      second_diagonal = s[2] + s[4] + s[6]
      [first_diagonal, second_diagonal]
    end

    # True if symbols are all equal. If a diagonal, row or column have the same
    # symbol, than there is a winnerj
    def identical_symbols(row_or_column)
      row_or_column[0] * 3 == row_or_column
    end

    # Convert symbol to player number. X is player1, 0 is player2
    def to_player_number(symbol)
      PLAYER_SYMBOLS.index(symbol) + 1
    end

    # Move to the next player
    def next_player
      current_player == 1 ? 2 : 1
    end
end
