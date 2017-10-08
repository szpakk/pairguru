require 'rails_helper'

RSpec.describe CommentDecorator do
  describe "#author" do
    let(:author) { create(:user) }
    let(:not_author) { create(:user) }
    let(:comment) { create(:comment, user_id: author.id ).decorate }

    it "returns name of user that posted this comment" do
      expect(comment.author).to eq(author.name)
    end

    it "doesn't return name of user that didn't post this comment" do
      expect(comment.author).not_to eq(not_author.name)
    end
  end
end
