class ReputationEvent < ActiveRecord::Base
  belongs_to :resource, :polymorphic => true
  belongs_to :user

  # index :user_id
  # index [:resource_id, :resource_type]

end
