require 'rails_helper'

RSpec.describe HomeController, :type => :controller do
  describe "GET home" do
    it "renders the home template" do
      get :home
      expect(response).to render_template("home/home")
    end
  end
end
