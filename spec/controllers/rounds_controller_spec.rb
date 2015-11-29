require 'rails_helper'

RSpec.describe RoundsController, type: :controller do
  before do
    @game = FactoryGirl.create(:game, player1: "one", player2: "two")
    @round = @game.round
  end

  describe "PUT #update" do
    describe "with valid params" do
      it "updates the requested level" do
        xhr :put, :update, {:game_id => @game.to_param, id: @round.to_param, round: {row:0, column: 0}}
        @round.reload
        expect(@round.board(row:0, column:0)).to eq "X"
      end
    end
  end
end
