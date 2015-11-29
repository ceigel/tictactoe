require 'rails_helper'

feature "game creation", type: :feature do

  scenario "has leaderboard table" do
    visit root_path
    expect(page.find_link('Home')[:href]).to eq root_path
    expect(page.find_link('New Game')[:href]).to eq new_game_path
  end
end


