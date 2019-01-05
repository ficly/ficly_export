require 'will_paginate'
class Comment < ActiveRecord::Base
	belongs_to :user
	belongs_to :resource, :polymorphic => true

	# index :user_id
	#index [:resource_id, :resource_type]

	validates_length_of :body,
		:in => 1..1024

	def to_html
		r = RedCloth.new(self.body)
		r.sanitize_html = true
		return r.to_html
	end

  def for_association
    out = {
      id: self.id,
      body: self.to_html,
      date: self.created_at,
      user: nil
    }

    if user.nil?
      out[:user] = {
        id: nil,
        name: "Deleted User",
        uri_name: ""
      }
    else
      out[:user] = self.user.for_association
    end

    out
  end

	protected

	def before_validation
    sanitizer = HTML::FullSanitizer.new
    self.body = sanitizer.sanitize(self.body.strip)
  end

	def after_create
		unless resource.nil?
			ReputationEvent.create(
			:resource => resource,
			:event_type => "comment",
			:user => user
			)
		end
	end
end
