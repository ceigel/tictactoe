require 'rails_helper'

def click_and_check_cell(row:, column:, text:)
  find(:xpath, "//tbody/tr[#{row}]/td[#{column}]").click
  expect(page.find(:xpath,  "//tbody/tr[#{row}]/td[#{column}]").text).to eq text
end

feature "leaderboard and games list", type: :feature, js:true do
  before(:all) do
    @game = FactoryGirl.create(:game, player1: 'one', player2: 'two')
  end

  scenario "has leaderboard table" do
    visit game_path(@game)
    expect(page.all(:xpath, '//tbody/tr/td')).to have_content ''
    click_and_check_cell(row: 1, column: 1, text: 'X')
    click_and_check_cell(row: 2, column: 1, text: '0')
    click_and_check_cell(row: 1, column: 2, text: 'X')
    click_and_check_cell(row: 2, column: 2, text: '0')
    click_and_check_cell(row: 1, column: 3, text: 'X')
    expect(page).to have_content('Player one won')
    expect(page).to have_link('Next Game')
    click_link('Next Game')
    expect(page.all(:xpath, '//tbody/tr/td')).to have_content ''
  end

  scenario "can't click twice on the same cell" do
    visit game_path(@game)
    click_and_check_cell(row: 1, column: 1, text: '0')
    click_and_check_cell(row: 1, column: 1, text: '0')
    click_and_check_cell(row: 2, column: 1, text: 'X')
    click_and_check_cell(row: 2, column: 1, text: 'X')
  end
end

