module RoundsHelper
  def player_name_field(player_name, index, score, current_player)
    extra_class = current_player == index ? "current_player": ""
    t1 = content_tag :strong, "Player: #{player_name}", class: extra_class
    t2 = content_tag :span, score, class: "pull-right"
    t1 + t2
  end

  def cell_html(round, row, col)
    cell_text = round.board(row: row, column: col)
    cell_text.sub!("_", "")
    clickable = cell_text.empty? && !round.finished?
    cell = content_tag :td, cell_text, data: { clickable: clickable, link: game_round_path(round.game, round, round: {row: row, column: col}), next: round.current_symbol}
  end
end

