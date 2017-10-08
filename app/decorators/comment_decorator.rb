class CommentDecorator < Draper::Decorator
  delegate_all

  def author
    object.user.name
  end
end
