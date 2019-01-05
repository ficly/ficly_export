class ActivityHistory < ActiveRecord::Base
	belongs_to :story
	# index :active_at
	# index [:active_at,:story_id]
end
