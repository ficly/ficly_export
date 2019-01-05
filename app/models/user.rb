require "will_paginate"

class User < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper

	attr_accessor :delete_ok
	#attr_accessible :name, :url_title, :bio, :uri_name, :icon_id, :url, :show_mature, :email, :send_new_comments, :send_daily_activity, :send_new_challenge_entries, :send_new_sequels, :send_new_notes, :delete_ok

  scope :active, -> { where(active: true) }

	has_many :stories
	has_many :published_stories,
    -> { where.not(published_at: nil).order('published_at desc') },
		:class_name => "Story"

	has_many :blog_posts
	has_many :challenges
	has_many :comments
	has_many :story_comments,
    -> { where "resource_type = 'Story'" },
		:class_name => "Comment"

	has_many :challenge_comments,
    -> { where "resource_type = 'Challenge'" },
		:class_name => "Comment"

	has_many :challenge_submissions

	has_many :activities

	has_many :recent_activities,
		:class_name => "Activity"

	has_many :observations,
		:class_name => "Activity",
		:foreign_key => "recipient_id"

	has_many :recent_observations,
    -> { where "recipient_id != user_id" },
		:class_name => "Activity",
		:foreign_key => "recipient_id"

	has_many :friendships,
    -> { includes :friend }

	has_many :friends,
		:through => :friendships

	has_many :followships,
		:class_name => "Friendship",
		:foreign_key => "friend_id"

	has_many :followers,
		:through => :followships,
		:class_name => "User",
		:source => :user

	has_many :icons
  has_one :icon, -> { order("id desc") }

	has_many :reputation_events,
		:as => :resource

	has_many :recent_reputation_events,
    -> { where ["created_at > ?",30.days.ago] },
		:class_name => "ReputationEvent",
		:foreign_key => "user_id"

	validates_uniqueness_of :uri_name
	validates_uniqueness_of :login_key
	validates_uniqueness_of :email, :allow_nil => true, :allow_blank => true

	def self.update_solr
		self.find_each do |u|
			u.solr_save
		end
	end

	# find by login cookie
	def self.find_by_login_cookie(cookie)
#		token = CryptoMan.decrypt(cookie).split(' | ')
#		u = find_by_id(token[0])
		return nil unless u && u.login_key == token[1]
		return u
	end

	def self.calculate_activity_rating
		self.find_in_batches do |records|
			records.each do |user|
				user.calculate_activity_rating
				user.save!
			end
		end
	end

	def calculate_activity_rating
	    events = self.recent_reputation_events
		self.activity_rating = 0
		self.authorship_rating = 0
		self.commenter_rating = 0
		self.continuity_rating = 0
		self.challenger_rating = 0
	    events.each do |event|
			if event.event_type == "story_published"
				self.increment(:activity_rating,20)
				self.increment(:authorship_rating,3)
			elsif event.event_type == "challenge_create"
				self.increment(:activity_rating,15)
				self.increment(:authorshop_rating,1)
				self.increment(:challenger_rating,1)
			elsif event.event_type == "challenge_submission_create"
				self.increment(:activity_rating,12)
				self.increment(:authorship_rating,1)
				self.increment(:continuity_rating,1)
				self.increment(:challenger_rating,3)
			elsif event.event_type == ("sequel" || "prequel")
				self.increment(:authorship_rating,1)
				self.increment(:continuity_rating,3) unless event.user_id == self.id
				self.increment(:continuity_rating,-1) if event.user_id == self.id
				self.increment(:activity_rating,25) unless event.user_id == self.id
			elsif event.event_type == "comment"
				self.increment(:commenter_rating,5) unless event.user_id == self.id
				self.increment(:activity_rating,10) unless event.user_id == self.id
			elsif event.event_type == "rating"
				self.increment(:commenter_rating,1) unless event.user_id == self.id
				self.increment(:commenter_rating,-2) if event.user_id == self.id
				self.increment(:activity_rating,3) unless event.user_id == self.id
			elsif event.event_type == "view"
				self.increment(:activity_rating,1)
			end
	    end
		return true
	end

	#  generate the login cookie
	def login_cookie
#		return CryptoMan.encrypt("#{id} | #{login_key}")
	end

	def published_count
		self.stories.published.count
	end

	def draft_count
		self.stories.drafts.count
	end

	def unread_note_count
		self.received_notes.unread.count
	end

	def has_uri?
		if self.uri_name.blank?
			false
		else
			true
		end
	end

  def bio_snippet
    @bio_snippet ||= strip_tags(textilize(self.bio)).truncate(244, omission: "...")
  end

	def has_default_uri_name?
		self.uri_name == "user-#{self.id}"
	end

	def is_friend?(user_id)
		f = self.friendships.find_by_friend_id(user_id)
		if f
			return true
		else
			return false
		end
	end

	def short_url
		"http://a.ficly.com/#{self.uri_name}"
	end

  def self.default_avatar
    "/images/icons/avatar.jpg"
  end

  def self.default_user
    {
      name: "Deleted User",
      avatar: self.default_avatar,
      uri_name: "",
      id: nil
    }
  end

	def avatar
		unless self.icon.nil?
      self.icon.url
			#if RAILS_ENV == 'production'
			#return "/images/icons/#{self.icon.id}/#{self.icon.filename}"
			#else
			#	return self.icon.url.to_s
			#end
		else
			return "/icons/avatar.jpg"
		end
	end

	def returns_friendship?(user_id)
		if Friendship.find_by_user_id(user_id, :conditions => ["friend_id = ?",self.id])
			true
		else
			false
		end
	end

	def friends_activity(page=1,per_page=10)
		return [] if self.friend_ids.empty?
		activity = []
		begin
			activity = Activity.paginate(:page => page, :per_page => per_page, :conditions => {:user_id => self.friend_ids}, :order => "id desc",:include => :user)
		rescue Exception
			Activity.without_cache do
				activity = Activity.paginate(:page => page, :per_page => per_page, :conditions => {:user_id => self.friend_ids}, :order => "id desc",:include => :user)
			end
		end
		return activity
	end

	def friends_stories(page=1,per_page=10)
		return [] if self.friend_ids.empty?
		Story.published.paginate(:page => page, :conditions => {:user_id => self.friend_ids}, :order => "published_at desc", :per_page => per_page)
	end

	def self.clean_uri(s)
		s.downcase.gsub(/[^a-z0-9_]+/i, '-')
	end

  def self.for_association(user)
    if user.nil?
      self.default_user
    else
      user.for_association
    end
  end

  def for_association
    {
      id: self.id,
      name: self.name,
      uri_name: self.uri_name,
      avatar: self.avatar
    }
  end

  def hugo_json
    out = {
      id: self.id,
      title: self.name,
      name: self.name,
      description: bio,
      slug: uri_name,
      date: self.created_at,
      url: url,
      url_title: url_title,
      avatar: avatar,
      stories: [],
      friends: [],
      challenges: [],
      taxonomies: ["authors"],
      type: "author"
    }

    self.stories.published.find_each do |s|
      out[:stories] << {
        id: s.id,
        title: s.title
      }
    end

    self.friends.find_each do |f|
      out[:friends] << f.for_association
    end

    self.challenges.find_each do |c|
      out[:challenges] << {
        id: c.id,
        title: c.title
      }
    end

    out[:stories_published] = out[:stories].length
    out[:n_friends] = out[:friends].length
    out[:n_challenges] = out[:challenges].length

    out
  end

  def hugo_export
    json = JSON.pretty_generate(self.hugo_json)
    begin
      @md_body = Timeout::timeout(5) do
        PandocRuby.convert(self.bio, from: :textile, to: :markdown)
      end
    rescue
      @md_body = self.bio
    end

<<-eos
#{json}

#{@md_body}
eos
  end

  def self.hugo_export
    user_dir = "#{Rails.root}/tmp/hugo/author"
    FileUtils.mkdir_p(user_dir)

    User.find_each do |u|
      puts "Writing: #{u.id}"
      FileUtils.mkdir_p("#{user_dir}/#{u.uri_name}")
      f = File.open("#{user_dir}/#{u.uri_name}/index.md","w+")
      f.puts u.hugo_export
      f.close
    end
  end

	protected

	def delete_content
		self.stories.find_each do |story|
			if story.sequels.count < 1 && story.prequels.count < 1
				story.comments.delete_all
				story.destroy
			end
		end
		self.challenges.find_each do |challenge|
			if challenge.challenge_submissions.count < 1
				challenge.comments.delete_all
				challenge.destroy
			end
		end
		self.comments.destroy_all
		self.icons.destroy_all
		self.friendships.destroy_all
		self.activities.destroy_all
		self.reputation_events.delete_all
		self.followships.destroy_all
		true
	end

	def before_destroy
		self.delete_content
	end

	def before_validation
		if self.uri_name_changed?
			self.uri_name = User.clean_uri(self.uri_name)
		end
		if self.name_changed?
			self.name = self.name.strip
		end
	end

	def before_save
		if !self.new_record? && self.uri_name.blank?
			self.uri_name = "user-#{self.id}"
		end
		if !self.url.blank? && !self.url.include?("http://")
			self.url = "http://"+self.url
		end
		if self.user_is_deleted? && self.user_is_deleted_changed?
			self.login_key = "http://ficly.com/deleted/#{Time.now.to_i}/#{rand(10000)}/#{rand(100)}"
			self.name = "Former Ficly Friend"
			self.url = ""
			self.bio = "This user is no longer a Ficly member. All that remains of their time on the site are stories they wrote that had prequels or sequels, challenges they created that had entires, and notes they sent to other users."
			self.icon_id = nil
			self.delete_content
		end
	end

end
