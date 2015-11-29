class Round < ActiveRecord::Base
  belongs_to :game
  validates :current_player, numericality: { only_integer: true, greater_than_or_equal_to: 1}
  validates :current_player, numericality: { only_integer: true, less_than_or_equal_to: 2}

  def start_new(player)
    self.update(current_player: player, board_state: '_' * 9)
  end

  def make_move(row: , column: )
    symbol = current_symbol
    raise 'Round finished' if finished?
    raise 'Move already taken' if board(row: row, column: column) != '_'
    board_state[index_from_row_column(row, column)] = symbol
    self.update(board_state: board_state, current_player: next_player)
  end

  def board(row:, column:)
    board_state[index_from_row_column(row, column)]
  end

  def finished?
    symbols_count = PLAYER_SYMBOLS.map{|s| board_state.count(s)}.inject(&:+)
    symbols_count == 9 || !winner.nil?
  end

  def current_symbol
    if current_player < 1 || current_player > 2
      raise "Impossible value for current_player #{current_player}"
    end
    return PLAYER_SYMBOLS[current_player - 1]
  end

  # returns player who won
  # or nil if no player won
  # we ignore the case when both players won
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

    def rows
      3.times.map{|n| board_state[n * 3, 3]}
    end

    def columns
      s = board_state
      3.times.map{|n| s[n] + s[n + 3] + s[n + 6]}
    end

    def diagonals
      s = board_state
      first_diagonal = s[0] + s[4] + s[8]
      second_diagonal = s[2] + s[4] + s[6]
      [first_diagonal, second_diagonal]
    end

    def identical_symbols(row_or_column)
      row_or_column[0] * 3 == row_or_column
    end

    def to_player_number(symbol)
      PLAYER_SYMBOLS.index(symbol) + 1
    end

    def next_player
      current_player == 1 ? 2 : 1
    end
end
