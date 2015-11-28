module GamesHelper
  def player_name_field(player_name, index, score, current_player)
    extra_class = current_player == index ? "current_player": ""
    t1 = content_tag :strong, "Player: #{player_name}", class: extra_class 
    t2 = content_tag :span, score, class: "pull-right"
    t1 + t2
  end

  def cell_html(round, row, col)
    cell_text = round.board(row: row, column: col)
    cell_text == "_" ? link_to_cell_update(round: round, row: row, column: col): cell_text
  end
  private
    def link_to_cell_update(round:, row:, column:)
      link_to "_", game_round_path(round.game, round, round: {row: row, column: column}), method: :patch, remote: true
    end
end
