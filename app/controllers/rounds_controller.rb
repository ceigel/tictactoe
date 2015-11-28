class RoundsController < ApplicationController
  def update
    @round = Round.find(params[:id])
    @game = @round.game
    make_round_move(round_params["row"], round_params["column"])
    if @round.finished?
      message_round_finished
      @game.register_round_finished
    end
  end

  private
    def round_params
      params.require(:round).permit(:row, :column)
    end

    def make_round_move(row, col)
      p = round_params
      @round.make_move(row: row.to_i, column: col.to_i)
    end

    def message_round_finished
      if @round.winner.nil?
        flash.now[:notice] = "Game ended in draw"
      else
        flash.now[:notice] = "Player #{player_name(@round.winner)} won"
      end
    end

    def player_name(player_number)
      @game.player_name(player_number)
    end
end
