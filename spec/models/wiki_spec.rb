require 'rails_helper'

RSpec.describe Wiki, type: :model do
  let(:user) { create(:user) }
  let(:wiki) { create(:wiki, user: user) }

  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to validate_presence_of(:user) }

  it { is_expected.to validate_length_of(:title).is_at_least(2) }
  it { is_expected.to validate_length_of(:body).is_at_least(15) }

  describe "attributes" do
    it "has title, body, private, and user attributes" do
      expect(wiki).to have_attributes(title: wiki.title, body: wiki.body, private: false, user: user)
    end
  end
end
