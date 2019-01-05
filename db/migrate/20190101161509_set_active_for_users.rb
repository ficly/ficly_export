class SetActiveForUsers < ActiveRecord::Migration[5.2]
  def change
    User.find_each do |user|
      user.active = (user.published_stories.any? || user.comments.any? || user.friends.any? || user.challenges.any? || user.blog_posts.any?)
      user.save if user.changed?
    end
  end
end
