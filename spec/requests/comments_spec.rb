require "rails_helper"
include Warden::Test::Helpers

describe "Comments requests", type: :request do
  let!(:movie) { create(:movie) }
  let(:comment_attributes) { FactoryGirl.attributes_for(:comment) }
  context "User is not logged in" do
    it "denies access to comments#create" do
      expect {
        post "/movies/#{movie.id}/comments", params: { comment: comment_attributes } 
      }.to_not change(Comment, :count)
    end

    it "denies access to comments#create" do
      comment = create(:comment)

      expect {
        delete "/movies/#{movie.id}/comments/#{comment.id}"
      }.to_not change(Comment, :count)
    end
  end

  context "User is logged in" do
    let(:user) { create(:user) }
    
    before(:each) do
      login_as(user)
    end

    it "allows user to create one comment" do
      expect {
        post "/movies/#{movie.id}/comments", params: { comment: comment_attributes } 
      }.to change(Comment, :count).by(1)

      expect(response).to redirect_to("/movies/#{movie.id}")
      follow_redirect!

      expect {
        post "/movies/#{movie.id}/comments", params: { comment: comment_attributes } 
      }.to_not change(Comment, :count)

      expect(response).to redirect_to("/movies/#{movie.id}")
      follow_redirect!
      expect(response.body).to include("Unable to add comment")
    end

    it "doesn't allow user to create blank comment" do
      expect {
        post "/movies/#{movie.id}/comments", params: { comment: { body: "" } } 
      }.not_to change(Comment, :count)

      expect(response).to redirect_to("/movies/#{movie.id}")
      follow_redirect!
      expect(response.body).to include("Unable to add comment")
    end

    it "allows user to delete own comment" do
      comment = create(:comment, user_id: user.id, movie_id: movie.id )

      expect {
        delete "/movies/#{movie.id}/comments/#{comment.id}"
      }.to change(Comment, :count).by(-1)
      
      expect(response).to redirect_to("/movies/#{movie.id}")
      follow_redirect!
      expect(response.body).not_to include(comment.body)
    end

    it "allows user to add comment after deletion" do
      comment = create(:comment, user_id: user.id, movie_id: movie.id )

      delete "/movies/#{movie.id}/comments/#{comment.id}"
      
      expect {
        post "/movies/#{movie.id}/comments", params: { comment: comment_attributes } 
      }.to change(Comment, :count).by(1)
    end

    it "doesn't allow user to delete other user's comment" do
      user2 = create(:user)
      comment = create(:comment, user_id: user2.id, movie_id: movie.id )

      expect {
        delete "/movies/#{movie.id}/comments/#{comment.id}"
      }.not_to change(Comment, :count)

      expect(response).to redirect_to("/movies/#{movie.id}")
      follow_redirect!
      expect(response.body).to include(comment.body)
    end
  end
end
