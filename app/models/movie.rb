# == Schema Information
#
# Table name: movies
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  released_at :datetime
#  avatar      :string
#  genre_id    :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Movie < ApplicationRecord
  belongs_to :genre
  has_many   :comments

  validates_with TitleBracketsValidator

  def comments_desc
    self.comments.order("created_at DESC").decorate
  end

  def has_comments?
    !self.comments.empty?
  end
end
