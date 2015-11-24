require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:game) { FactoryGirl.create(:game) }

  subject { game }

  it { is_expected.to be_valid }
  it { is_expected.to respond_to :player1 }
  it { is_expected.to respond_to :player2 }
  it { is_expected.to respond_to :score_player1 }
  it { is_expected.to respond_to :score_player2 }

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
end
