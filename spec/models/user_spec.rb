require "rails_helper"

describe User do
  describe "phone number validation" do
    it { is_expected.to allow_value("+48 999 888 777").for(:phone_number) }
    it { is_expected.to allow_value("48 999-888-777").for(:phone_number) }
    it { is_expected.to allow_value("48 999-888-777").for(:phone_number) }
    it { is_expected.not_to allow_value("+48 aaa bbb ccc").for(:phone_number) }
    it { is_expected.not_to allow_value("aaa +48 aaa bbb ccc").for(:phone_number) }
    it { is_expected.not_to allow_value("+48 999 888 777\naseasd").for(:phone_number) }
  end

  describe "#top_commenters" do
    let!(:user_list) { create_list(:user, 11) }
    let(:users) { User.all }
    
    context "without comments" do
      it "returns an empty collection" do
        expect(users.top_commenters).to be_empty
      end
    end

    context "with comments" do
      it "contains users that have commented" do
        comment1 = create(:comment, created_at: Time.now - 1.hour, user_id: user_list[0].id)
        comment2 = create(:comment, created_at: Time.now - 1.day, user_id: user_list[1].id)
        expect(users.top_commenters).to include(user_list[0], user_list[1])
      end

      it "doesn't contain users that have commented over 7 days ago" do
        comment = create(:comment, created_at: Time.now - 7.days - 1.second, user_id: user_list[0].id)
        expect(users.top_commenters).to be_empty
      end

      it "is limited to 10 users" do
        11.times { |i| create(:comment, user_id: user_list[i].id) }
        expect(users.top_commenters.size.size).to eq(10)
      end

      it "sorts users by the number of posted comments" do
        create(:comment, user_id: user_list[0].id)
        3.times { create(:comment, user_id: user_list[1].id)}
        2.times { create(:comment, user_id: user_list[2].id)}

        expect(users.top_commenters).to eq([user_list[1], user_list[2], user_list[0]])
      end
    end

  end
end
