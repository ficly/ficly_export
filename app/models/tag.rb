class Tag < ActiveRecord::Base

  has_many :taggings

  def self.clean_tag(tag)
    return nil if tag.blank?
    tag.squish.strip.downcase.gsub(" ","-").gsub(/[^a-z0-9:-]/,"").gsub("--", "-")
  end

  def self.clean_tags(tags)
    if tags.is_a?(String)
      tags = tags.split(",")
    end
    tags.map do |tag|
      Tag.clean_tag(tag)
    end
  end

end
