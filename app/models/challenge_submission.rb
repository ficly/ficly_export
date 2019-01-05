require 'will_paginate'
class ChallengeSubmission < ActiveRecord::Base
  belongs_to :user
  belongs_to :story
  belongs_to :challenge

  # index :user_id
  # index :story_id
  # index :challenge_id

  protected
  
    def after_create
      self.challenge.reputation_events.create(
        :user_id => self.user_id,
        :event_type => "challenge_submission_create"
      )
    end

end
