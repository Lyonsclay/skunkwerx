require 'spec_helper'

describe Admin::SessionsController do
  let(:admin) { create(:admin) }

  describe "GET new" do
    it "renders the login form" do
      get 'new'
      expect(response).to render_template("new")
    end
  end

  describe "create session" do
    it "should create new session with valid login" do
      post :create, session: { email: admin.email, password: admin.password }
    end

    it "should redirect to admin after valid login" do
    end
  end
end
