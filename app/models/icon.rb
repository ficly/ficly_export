class Icon < ActiveRecord::Base
  belongs_to :user

  # has_attached_file :avatar, :storage => :s3,
  #   :content_type => :image,
  #   :resize_to => [73,73],
  #   :file_name => "avatar.jpg",
  #   :size => 1.kilobyte..2.megabytes,
  #   :s3_region => "us-east-1"
  #
  # validates_attachment :avatar, content_type: { content_type: "image/*" }

	# index :user_id

	def before_create
		self.filename = "avatar.jpg"
	end

  def after_create
    self.user.update_attribute(:icon_id,self.id)
  end

  def url
    "/icons/#{self.id}/#{self.filename}"
  end

end
