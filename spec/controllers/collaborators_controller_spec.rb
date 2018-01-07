require 'rails_helper'

RSpec.describe CollaboratorsController, type: :controller do
  let(:my_user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:third_user) { create(:user) }
  let(:user_wiki) { create(:wiki, user: my_user, private: true) }
  let(:other_user_wiki) { create(:wiki, user: other_user, private: true) }
  let(:public_wiki) { create(:wiki, user: my_user) }
  let(:collaboration) { Collaborator.create!(wiki_id: other_user_wiki.id, user_id: my_user.id) }
  let(:destroy_collaboration) { Collaborator.create!(wiki_id: user_wiki.id, user_id: third_user.id) }

  context 'guest user' do
    describe "GET new" do
      it "redirects the user to the sign in view" do
        get :new, wiki_id: user_wiki.id
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'POST create' do
      it 'redirects the user to the sign in view' do
        post :create, { wiki_id: user_wiki.id, user_id: other_user.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'DELETE destroy' do
      it 'redirects the user to the sign in view' do
        delete :destroy, { wiki_id: other_user_wiki.id, id: collaboration.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  context 'signed in standard user' do
    before do
      my_user.confirm
      sign_in my_user
    end

    describe 'GET new' do
      it 'redirects the standard user to the upgrade page' do
        get :new, wiki_id: user_wiki.id
        expect(response).to redirect_to(new_charge_path)
      end
    end

    describe 'POST create' do
      it 'redirects the standard user to the upgrade page' do
        post :create, wiki_id: user_wiki.id, collaborator: {wiki_id: user_wiki.id, user_id: other_user.id}
        expect(response).to redirect_to(new_charge_path)
      end
    end

    describe 'DELETE destroy' do
      it 'redirects the standard user to the upgrade page' do
        delete :destroy, { wiki_id: other_user_wiki.id, id: collaboration.id }
        expect(response).to redirect_to(new_charge_path)
      end
    end
  end

  context "premium user modifying collaborators on a wiki they don't own" do
    before do
      my_user.confirm
      my_user.premium!
      sign_in my_user
    end

    describe 'GET new' do
      it "returns http redirect" do
        get :new, wiki_id: other_user_wiki.id
        expect(response).to redirect_to(other_user_wiki)
      end
    end

    describe 'POST create' do
      it "returns http redirect" do
        post :create, wiki_id: other_user_wiki.id, collaborator: {wiki_id: other_user_wiki.id, user_id: my_user.id}
        expect(response).to redirect_to(other_user_wiki)
      end
    end

    describe 'DELETE destroy' do
      it "returns http redirect" do
        delete :destroy, { wiki_id: other_user_wiki.id, id: collaboration.id }
        expect(response).to redirect_to(other_user_wiki)
      end
    end
  end

  context "premium user modifying colalborators on a wiki they own" do
    before do
      my_user.confirm
      my_user.premium!
      sign_in my_user
    end

    describe 'GET new' do
      it "returns http success" do
        get :new, wiki_id: user_wiki.id
        expect(response).to have_http_status(:success)
      end

      it "renders the #new view" do
        get :new, wiki_id: user_wiki.id
        expect(response).to render_template :new
      end

      it "initializes @collaborator" do
        get :new, wiki_id: user_wiki.id
        expect(assigns(:collaborator)).not_to be_nil
      end
    end

    describe "POST create" do
      it "increases the number of collaborators by 1" do
        expect{ post :create, wiki_id: user_wiki.id, collaborator: {wiki_id: user_wiki.id, user_id: other_user.email } }.to change(Collaborator,:count).by(1)
      end

      it "redirects to the wiki" do
        post :create, wiki_id: user_wiki.id, collaborator: {wiki_id: user_wiki.id, user_id: other_user.email}
        expect(response).to redirect_to user_wiki
      end
    end

    describe "DELETE destroy" do
      it "deletes the collaborator" do
        delete :destroy, { wiki_id: user_wiki.id, id: destroy_collaboration.id }
        count = Collaborator.where({id: destroy_collaboration.id }).size
        expect(count).to eq 0
      end

      it "redirects to the wiki" do
        delete :destroy, { wiki_id: user_wiki.id, id: destroy_collaboration.id }
        expect(response).to redirect_to user_wiki
      end
    end
  end

  context "premium user modifying collaborators on a public wiki" do
    before do
      my_user.confirm
      my_user.premium!
      sign_in my_user
    end

    describe 'GET new' do
      it "returns http redirect" do
        get :new, wiki_id: public_wiki.id
        expect(response).to redirect_to(public_wiki)
      end
    end

    describe 'POST create' do
      it "returns http redirect" do
        post :create, wiki_id: public_wiki.id, collaborator: {wiki_id: public_wiki.id, user_id: my_user.id}
        expect(response).to redirect_to(public_wiki)
      end
    end

    describe 'DELETE destroy' do
      it "returns http redirect" do
        delete :destroy, { wiki_id: public_wiki.id, id: collaboration.id }
        expect(response).to redirect_to(public_wiki)
      end
    end
  end
end
