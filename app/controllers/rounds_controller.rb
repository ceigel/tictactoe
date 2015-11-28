class RoundsController < ApplicationController
  respond_to :html
  def update
    @round = Round.find(params[:id])
    @game = @round.game
    @round.make_move(*round_params)
    if @round.finished
      @game.register_round_finished
    end

    respond_with(@game)
  end
  private
    def round_params
      params.require(:round).permit(:row, :column)
    end
end
