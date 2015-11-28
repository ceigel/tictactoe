require 'rails_helper'


RSpec.describe GamesController, type: :controller do

  let(:valid_attributes) { FactoryGirl.attributes_for(:game) }

  let(:invalid_attributes) { FactoryGirl.attributes_for(:game, player1: nil) }


  describe "GET #index" do
    it "assigns all games as @games" do
      game = Game.create! valid_attributes
      get :index, {}
      expect(assigns(:games)).to eq([game])
    end
  end

  describe "GET #show" do
    it "assigns the requested game as @game" do
      game = Game.create! valid_attributes
      get :show, {:id => game.to_param}
      expect(assigns(:game)).to eq(game)
    end
  end

  describe "GET #new" do
    it "assigns a new game as @game" do
      get :new, {}
      expect(assigns(:game)).to be_a_new(Game)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Game" do
        expect {
          post :create, {:game => valid_attributes}
        }.to change(Game, :count).by(1)
      end

      it "assigns a newly created game as @game" do
        post :create, {:game => valid_attributes}
        expect(assigns(:game)).to be_a(Game)
        expect(assigns(:game)).to be_persisted
      end

      it "redirects to the created game" do
        post :create, {:game => valid_attributes}
        expect(response).to redirect_to(Game.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved game as @game" do
        post :create, {:game => invalid_attributes}
        expect(assigns(:game)).to be_a_new(Game)
      end

      it "re-renders the 'new' template" do
        post :create, {:game => invalid_attributes}
        expect(response).to render_template("new")
      end
    end
  end
end
