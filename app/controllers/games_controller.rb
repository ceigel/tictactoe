class GamesController < ApplicationController
  before_action :set_game, only: [:show]

  def index
    @games = Game.all
    @leaders = get_leaderboard
  end

  def show
    @round = @game.round
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game }
      else
        format.html { render :new }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:player1, :player2, :score_player1, :score_player2)
    end

    def get_leaderboard
      h1 = Game.group(:player1).sum(:score_player1)
      h2 = Game.group(:player2).sum(:score_player2)
      leaderboard = h1.merge(h2){|k, v1, v2| v1 + v2 }.to_a
      leaderboard.sort_by{|p, s| -s}
    end
end
