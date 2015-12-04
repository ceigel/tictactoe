class RoundsController < ApplicationController
  # Called when player makes a new move.
  # The cells in the player board are AJAX calls into this method.
  # Registers the move.
  # When the round is finished, the Game#register_round_finished is called
  # The play-table is updated from update.js.erb
  def update
    @round = Round.find(params[:id])
    @game = @round.game
    make_round_move(round_params["row"], round_params["column"])
    update_on_round_finished if @round.finished?
  end

  # Called when user clicks "Next Round"
  # It tells the game to move to next round (clean table and update play_count)
  def create
    @game = Game.find(params[:game_id])
    @game.next_round
    redirect_to @game
  end

  private
    # Update game when round is finished
    def update_on_round_finished
      flash.now[:notice] = message_round_finished
      @game.register_round_finished
    end

    # Tell round to make move
    def make_round_move(row, col)
      @round.make_move(row: row.to_i, column: col.to_i)
    end

    # The message to be displayed when a round is finished (won/draw)
    def message_round_finished
      if @round.winner.nil?
        "Game ended in draw"
      else
        "Player #{player_name(@round.winner)} won"
      end
    end

    def player_name(player_number)
      @game.player_name(player_number)
    end

    def round_params
      params.require(:round).permit(:row, :column)
    end
end
