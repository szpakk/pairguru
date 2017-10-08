require 'rails_helper'

RSpec.describe Movie, type: :model do
  let(:movie) { create(:movie) }
  
  
  describe "#comments_desc" do
    it "returns comments collection sorted by creation time descending" do
      comment_1 = create(:comment, created_at: Time.now - 1.hour)
      comment_2 = create(:comment, created_at: Time.now)
      comment_3 = create(:comment, created_at: Time.now - 30.minutes)
      movie.comments = [comment_1, comment_2, comment_3]

      expect(movie.comments_desc).to eq([comment_2, comment_3, comment_1])
    end

    it "returns empty collection if movie is uncommented" do
      expect(movie.comments_desc).to be_empty
    end
  end

  describe "#has_comments?" do
    it "returns true if movie was commented on" do
      comment = create(:comment, movie_id: movie.id)

      expect(movie.has_comments?).to be true
    end

    it "returns false if movie wasn't commented on" do
      expect(movie.has_comments?).to be false
    end
  end   
end
