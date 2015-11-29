require 'rails_helper'

feature "leaderboard and games list", type: :feature do
  before do
    FactoryGirl.create(:game, player1: 'one', player2: 'two')
    FactoryGirl.create(:game, player1: 'two', player2: 'three')
  end

  scenario "has leaderboard table" do
    visit root_path
    within('#leaderboard') do
      expect(page).to have_content 'Leaderboard'
      expect(page).to have_content 'one'
      expect(page).to have_content 'two'
      expect(page).to have_content 'three'
      within('tbody tr:first') do
        expect(page).to have_content 'two'
        expect(page).to have_content '15'
      end
    end
  end

  scenario 'has games table' do
    visit root_path
    within('#games_list') do
      expect(page).to have_content 'Games'
      expect(page).to have_selector('tbody tr', count: 2)
      expect(page).to have_content 'one'
      expect(page).to have_content 'two'
      expect(page).to have_content 'three'

    end
  end

  scenario 'games are displayed in reverse order' do
    visit root_path
    within('#games_list tbody tr:first') do
      expect(page).to have_content 'three'
      expect(page).to have_content 'two'
    end
  end
end
