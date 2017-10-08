class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :movie

  validates :body, presence: true
  validates :movie_id, presence: true
  validates :user_id, presence: true
  validates_uniqueness_of :user_id, scope: :movie_id
end
