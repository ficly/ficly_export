class Activity < ActiveRecord::Base
	# include ActionView::Helpers
	# include ActionView::Helpers::UrlHelper
	# include ActionController::Routing
	# include ActionController::Routing::Helpers
	# include ActionController::PolymorphicRoutes
	# include ActionController::Resources
	
	belongs_to :user
	belongs_to :recipient,
		:class_name => "User"
	belongs_to :resource, :polymorphic => :true

	# index :user_id
	# index :recipient_id
	# index :resource_id
	# index :resource_type
#	# index :resource_type, :resource_id

	validates_presence_of [:user_id, :recipient_id, :resource_id, :resource_type]

	def generate_html
		out = "#{link_to self.user.name, '/authors/' + self.user.uri_name } "
		l = out.length
		if self.resource_type == "Story"
			story_url = "/stories/#{self.resource_id.to_s}"
			if self.modifier == "sequel" || self.modifier == "prequel"
				if self.modifier == "sequel"
					other = self.resource.sequel
				else
					other = self.resource.prequel
				end
				out += "<strong>wrote a #{self.modifier}</strong>, #{link_to self.resource.title, story_url}, to #{link_to self.recipient.name.possessify, '/authors/' + self.recipient.uri_name } story #{link_to other.title, "/stories/#{other.id}"}."
			else
				out += "<strong>wrote</strong> #{link_to self.resource.title, story_url}."
			end
		elsif self.resource_type == "Comment"
			if self.resource.resource_type == "Story"
				story_url = "/stories/#{self.resource.resource_id}"
				out += "<strong>posted a comment</strong> on #{link_to self.recipient.name.possessify, '/authors/' + self.recipient.uri_name} story #{link_to self.resource.resource.title, story_url}."
			elsif self.resource.resource_type == "Challenge"
				challenge_url = "/challenges/#{self.resource.resource_id}"
				out += "<strong>posted a comment</strong> on #{link_to self.recipient.name.possessify, '/authors/' + self.recipient.uri_name} challenge #{link_to self.resource.resource.title, challenge_url}."
			else # It has to be a blog post - what else has comments?
				out += "<strong>posted a comment</strong> on the blog post #{link_to self.resource.resource.title, '/blog/' + self.resource.resource.basename}."
			end
		elsif self.resource_type == "Challenge"
			challenge_url = "/challenges/#{self.resource_id}"
			out += "<strong>created a challenge</strong> #{link_to self.resource.title, challenge_url}."
		elsif self.resource_type == "ChallengeSubmission"
			challenge_url = "/challenges/#{self.resource.challenge_id.to_s}"
			story_url = "/stories/#{self.resource.story_id.to_s}"
			out += "<strong>entered</strong> #{link_to self.resource.story.title, story_url} into #{link_to self.resource.challenge.title, challenge_url}."
		end
		if out.length > l
			self.cached_html = out
			return out
		else
			return nil
		end
	end

 	def before_save
		self.generate_html
 	end

	def to_html
 		self.cached_html || self.generate_html
	end

end
