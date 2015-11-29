class RoundsController < ApplicationController
  def update
    @round = Round.find(params[:id])
    @game = @round.game
    make_round_move(round_params["row"], round_params["column"])
    round_finished if @round.finished?
  end

  def create
    @game = Game.find(params[:game_id])
    @game.next_round
    redirect_to @game
  end

  private
    def round_finished
      flash.now[:notice] = message_round_finished
      @game.register_round_finished
    end
    def round_params
      params.require(:round).permit(:row, :column)
    end

    def make_round_move(row, col)
      p = round_params
      @round.make_move(row: row.to_i, column: col.to_i)
    end

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
end
