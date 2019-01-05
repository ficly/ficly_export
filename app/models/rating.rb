class Rating < ActiveRecord::Base
  belongs_to :resource, :polymorphic => true
  belongs_to :user

  # index :user_id
  # index [:resource_id, :resource_type]

  def after_create
    res = self.resource
    res.ratings_count = res.ratings_count+1
    res.total_ratings_score = res.total_ratings_score+self.score
    res.average_rating = res.ratings.average(:score).to_f
    res.save!

    ReputationEvent.create(
      :resource => res,
      :user => user,
      :event_type => "rating"
    )

  end

  def after_update
    if self.score_changed?
      res = self.resource
      res.total_ratings_score = res.total_ratings_score - self.score_was + self.score
      res.average_rating = res.total_ratings_score / res.ratings_count
      res.save!
    end
  end

  def after_destroy
    res = self.resource
    res.ratings_count = res.ratings_count - 1
    res.total_ratings_score = res.total_ratings_score - self.score
    res.average_rating = res.total_ratings_score / res.ratings_count
    res.save!
  end

end
