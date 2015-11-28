FactoryGirl.define do
  factory :round do
    board_state "XOXOXOXOX"
    game factory: :game
    current_player 1
  end
end
