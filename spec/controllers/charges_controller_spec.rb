require 'rails_helper'
include RandomData

RSpec.describe ChargesController, type: :controller do
  let(:my_user) { create(:user) }

  context "guest user" do
    describe "GET new" do
      it "sends guests to the sign up page" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  context "premium user" do
    before do
      my_user.confirm
      my_user.premium!
      sign_in my_user
    end

    describe "GET new" do
      it "sends already premium users to the wiki index" do
        get :new
        expect(response).to redirect_to(wikis_path)
      end
    end
  end

  context "standard user" do
    before do
      my_user.confirm
      sign_in my_user
    end

    describe "GET new" do
      it "returns https success" do
        get :new
        expect(response).to have_http_status(:success)
      end

      it "renders the #new view" do
        get :new
        expect(response).to render_template :new
      end
    end
  end
end
