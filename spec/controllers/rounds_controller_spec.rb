require 'rails_helper'

RSpec.describe RoundsController, type: :controller do
  before do
    @game = FactoryGirl.create(:game, player1: "one", player2: "two", score_player1: 0, score_player2: 0)
    @round = @game.round
  end

  describe "PATCH #update" do
    describe "with valid params" do
      it "registers the new move" do
        xhr :put, :update, {:game_id => @game.to_param, id: @round.to_param, round: {row:0, column: 0}}
        @round.reload
        expect(@round.board(row:0, column:0)).to eq 'X'
      end

      it "sets game and round correctly" do
        xhr :put, :update, {:game_id => @game.to_param, id: @round.to_param, round: {row:0, column: 0}}
        expect(assigns(:game)).to eq @game
        expect(assigns(:round)).to eq @round
      end
    end

    describe "last move" do
      before do
        @round.board_state = 'X00XX000_'
        @round.save
      end

      it "registers win for player1" do
        xhr :put, :update, {:game_id => @game.to_param, id: @round.to_param, round: {row:2, column: 2}}
        @game.reload
        expect(@game.score_player1).to eq 1
        expect(@game.score_player2).to eq 0
      end

    end
  end

  describe "POST #create" do
    it "redirects to game" do
      post :create, {:game_id => @game.to_param}
      expect(response).to redirect_to(@game)
    end

    it "increases play_count" do
      expect(@game.play_count).to eq 0
      post :create, {:game_id => @game.to_param}
      @game.reload
      expect(@game.play_count).to eq 1
    end

    it "resets round" do
      post :create, {:game_id => @game.to_param}
      @round.reload
      expect(@round.board_state).to eq '_' * 9
    end
  end
end
