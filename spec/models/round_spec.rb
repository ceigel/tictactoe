require 'rails_helper'

RSpec.describe Round, type: :model do
  let(:round) { FactoryGirl.create(:round) }

  subject { round }

  it { is_expected.to be_valid }
  it { is_expected.to respond_to :current_player }
  it { is_expected.to respond_to :board_state }
  it { is_expected.to respond_to :game }

  it 'is valid when built from parameters' do
    g = FactoryGirl.build(:round, board_state: '_' * 9, current_player: 1)
    expect(g).to be_valid
    expect(g.save).to eq true
  end

  it "is invalid with an current_player smaller than 1" do
    expect(FactoryGirl.build(:round, current_player: 0)).not_to be_valid
  end

  it "is invalid with an current_player bigger than 2" do
    expect(FactoryGirl.build(:round, current_player: 3)).not_to be_valid
  end

  describe "initial state" do
    before do
      @round = Round.new
    end
    it "is expected to have current_player equal to 1 by default" do
      expect(@round.current_player).to eq 1
    end

    it "is expected to have board state empty" do
      expect(@round.board_state).to eq '_' * 9
    end

  end

  describe "start_new" do
    before do
      round.start_new(2)
    end

    it "is expected to have current_player equal to 2" do
      expect(round.current_player).to eq 2
    end

    it "is expected to have an empty board" do
      expect(round.board_state).to eq '_' * 9
    end

    it "is expected to not be finished" do
      expect(round.finished?).to eq false
    end
  end

  describe "make_move" do
    before do
      round.start_new(2)
      round.make_move(row: 0, column: 0)
    end

    it "is expected to have registered move and with 0" do
      expect(round.board_state[0]).to eq '0'
    end

    it "is expected to change the current player" do
      expect(round.current_player).to eq 1
    end

    it "is expected not to have finished" do
      expect(round.finished?).to be false
    end

    describe "after second make_move" do
      before do
        round.make_move(row: 0, column: 1)
      end

      it "is expected to have registered move and with 1" do
        expect(round.board_state[1]).to eq 'X'
      end

      it "is expected to change the current player" do
        expect(round.current_player).to eq 2
      end

      it "is expected not to have finished" do
        expect(round.finished?).to be false
      end

      it "is expected to have no winner" do
        expect(round.winner).to be_nil
      end
    end
  end

  describe "row winner" do
    before do
      round.start_new(2)
      # 0 0 0
      # X X _
      # _ _ _
      round.make_move(row: 0, column: 0)
      round.make_move(row: 1, column: 0)
      round.make_move(row: 0, column: 1)
      round.make_move(row: 1, column: 1)
      round.make_move(row: 0, column: 2)
    end

    it "is expected to have ficolumn: nished" do
      expect(round.finished?).to be true
    end

    it "is expected to have the correct winner" do
      expect(round.winner).to eq 2
    end
  end

  describe "column winner" do
    before do
      round.start_new(1)
      # X 0 0
      # X X 0
      # X _ _
      round.make_move(row: 0, column: 0) # x
      round.make_move(row: 0, column: 1) # 0
      round.make_move(row: 1, column: 1) # x
      round.make_move(row: 0, column: 2) # 0
      round.make_move(row: 1, column: 0) # x
      round.make_move(row: 0, column: 2) # 0
      round.make_move(row: 2, column: 0) # x
    end

    it "is expected to have finished" do
      expect(round.finished?).to be true
    end

    it "is expected to have the correct winner" do
      expect(round.winner).to eq 1
    end
  end

  describe "diagonal winner" do
    before do
      # 0 0 x
      # x 0 x
      # 0 x 0
      round.start_new(2)
      round.make_move(row: 0, column: 0) # 0
      round.make_move(row: 1, column: 0) # x
      round.make_move(row: 0, column: 1) # 0
      round.make_move(row: 0, column: 2) # x
      round.make_move(row: 1, column: 1) # 0
      round.make_move(row: 1, column: 2) # x
      round.make_move(row: 2, column: 0) # 0
      round.make_move(row: 2, column: 1) # x
      round.make_move(row: 2, column: 2) # 0
    end

    it "is expected to have finished" do
      expect(round.finished?).to be true
    end

    it "is expected to have no winner" do
      expect(round.winner).to eq 2
    end
  end

  describe "draw" do
    before do
      round.start_new(1)
      # X 0 X
      # X 0 X
      # 0 X 0
      round.make_move(row: 0, column: 0) # x
      round.make_move(row: 0, column: 1) # 0
      round.make_move(row: 1, column: 0) # x
      round.make_move(row: 1, column: 1) # 0
      round.make_move(row: 0, column: 2) # x
      round.make_move(row: 2, column: 0) # 0
      round.make_move(row: 1, column: 2) # x
      round.make_move(row: 2, column: 2) # 0
      round.make_move(row: 2, column: 1) # x
    end

    it "is expected to have finished" do
      expect(round.finished?).to be true
    end

    it "is expected to have no winner" do
      expect(round.winner).to be_nil
    end
  end
end
