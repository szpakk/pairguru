require "rails_helper"

describe "User requests", type: :request do
  describe "top commenters" do
    let!(:user) { create(:user) }
    let!(:users) { User.all }
    
    it "renders top commenters view" do
      get rankings_path
      expect(response.body).to include("User rankings")
    end

    it "displays top commenters" do
      comment = create(:comment, user_id: user.id)

      get rankings_path
      expect(response.body).to include(user.name)
    end

    it "doesn't display user without comment in last 7 days" do
      comment = create(:comment, user_id: user.id, created_at: Time.now - 7.days - 1.second)

      get rankings_path
      expect(response.body).not_to include(user.name)
    end
  end
end
