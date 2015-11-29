require 'rails_helper'

feature "game creation", type: :feature do
  before do
    @player1 = 'Bob'
    @player2 = 'George'
  end
  scenario "successful game creation" do
    visit new_game_path
    expect(page).to have_content('New Game')
    page.fill_in 'Player1', with: @player1
    page.fill_in 'Player2', with: @player2
    click_button 'Start Game'
    expect(page).to have_content(@player1)
    expect(page).to have_content('TicTacToe')
    expect(page).to have_selector('td', count: 9)
  end

  scenario 'game creation validation failed' do
    visit new_game_path
    page.fill_in 'Player1', with: @player1
    page.fill_in 'Player2', with: @player1
    click_button 'Start Game'
    within('#error_explanation') do
      expect(page).to have_content('Player2 should be different than player1')
    end
  end
end

