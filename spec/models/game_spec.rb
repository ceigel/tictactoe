require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:game) { FactoryGirl.create(:game) }

  subject { game }

  it { is_expected.to be_valid }
  it { is_expected.to respond_to :player1 }
  it { is_expected.to respond_to :player2 }
  it { is_expected.to respond_to :score_player1 }
  it { is_expected.to respond_to :score_player2 }
  it { is_expected.to respond_to :play_count }
  it { is_expected.to respond_to :round }

  it 'is valid when built from parameters' do
    g = FactoryGirl.build(:game, player1: "Test1", player2: "Test2")
    expect(g).to be_valid
    expect(g.save).to eq true
  end

  it "is invalid without first player's name" do
    expect(FactoryGirl.build(:game, player1: nil, player2: "Test")).not_to be_valid
  end

  it "is invalid without second player's name" do
    expect(FactoryGirl.build(:game, player1: "Test", player2: nil)).not_to be_valid
  end

  it "is invalid when the 2 player names are identical" do
    expect(FactoryGirl.build(:game, player1: "Test", player2: "Test")).not_to be_valid
  end

  it "is invalid when first player's name is longer than 100 characters" do
    expect(FactoryGirl.build(:game, player1: "Test" * 25 + "r", player2: "Test")).not_to be_valid
  end

  it "is invalid when second player's name is longer than 100 characters" do
    expect(FactoryGirl.build(:game, player1: "Test", player2: "Test" * 25 + "r" )).not_to be_valid
  end

  it "is invalid when player1 score is negative" do
    expect(FactoryGirl.build(:game, score_player1: -1)).not_to be_valid
  end

  it "is invalid when player2 score is negative" do
    expect(FactoryGirl.build(:game, score_player2: -1)).not_to be_valid
  end

  it "is invalid when play_count is negative" do
    expect(FactoryGirl.build(:game, play_count: -1)).not_to be_valid
  end

  describe "initialization" do
    before do
      @game = Game.new(player1: "one", player2: "two")
    end

    it "is expected play_count to equal 0" do
      expect(@game.play_count).to eq 0
    end

    it "is expected score_player1 to equal 0" do
      expect(@game.score_player1).to eq 0
    end

    it "is expected score_player2 to equal 0" do
      expect(@game.score_player2).to eq 0
    end
  end

  describe "start new round" do
    before do
      game.new_round
    end

    it "is expected that the current player to be the first player" do
      expect(game.round.current_player).to eq 1
    end

    it "is expected that the new round is unplayed" do
      expect(game.round.board_state).to eq '_' * 9
    end

    describe "start a second round" do
      before do
        game.round.make_move(row: 0, column: 0)
        game.new_round
      end

      it "is expected that the current player to be the second player" do
        expect(game.round.current_player).to eq 2
      end

      it "is expected that the new round is unplayed" do
        expect(game.round.board_state).to eq '_' * 9
      end
    end
  end
end
