require 'rails_helper'

RSpec.describe Comment, type: :model do
  context "with invalid attributes" do
    it "is invalid if body is blank" do
      comment = build(:comment, body: "")
      expect(comment).to be_invalid
    end

    it "is invalid without movie_id" do
      comment = build(:comment, movie_id: nil)
      expect(comment).to be_invalid
    end

    it "is invalid without user_id" do
      comment = build(:comment, user_id: nil)
      expect(comment).to be_invalid
    end

    it "is invalid if one user comments 2 times on one movie" do
      comment_1 = create(:comment, user_id: 1, movie_id: 1)
      comment_2 = build(:comment,user_id: 1, movie_id: 1)
      expect(comment_2).to be_invalid
    end
  end

  context "with valid attributes" do
    it "is valid if one user comments on 2 movies" do
      comment_1 = create(:comment, user_id: 1, movie_id: 1)
      comment_2 = build(:comment,user_id: 1, movie_id: 2)
      expect(comment_2).to be_valid
    end 

    it "is valid if two users comment on 1 movie" do
      comment_1 = create(:comment, user_id: 1, movie_id: 1)
      comment_2 = build(:comment,user_id: 2, movie_id: 1)
      expect(comment_2).to be_valid
    end
  end
end
