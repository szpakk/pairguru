class UsersController < ApplicationController
  expose(:top_users) { User.top_commenters }
  
  def rankings
  end
end
