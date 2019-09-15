class Tag < ActiveRecord::Base

  has_many :taggings

  def self.calculate_counts
    Tag.find_each do |t|
      t.calculate_counts
    end
  end

  def calculate_counts
    story_ids = self.taggings.where(taggable_type: "Story").pluck(:taggable_id)
    self.stories_count = Story.published.where(id: story_ids).count
    challenge_ids = self.taggings.where(taggable_type: "Challenge").pluck(:taggable_id)
    self.challenges_count = challenge_ids.length
    self.update_columns(stories_count: stories_count, challenges_count: challenges_count)
  end

  def stories
    @story_ids ||= self.taggings.where(taggable_type: "Story").distinct.pluck(:taggable_id)
    @stories ||= Story.published.where(id: @story_ids)
  end

  def challenges
    @challenge_ids ||= self.taggings.where(taggable_type: "Challenge").distinct.pluck(:taggable_id)
    @challenges ||= Challenge.where(id: @challenge_ids)
  end

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

  def self.clean_up_tags
    count = Tag.count
    out = []
    Tag.order("cleaned_tag asc").each do |tag|
      if Tag.where(cleaned_tag: tag.cleaned_tag).count > 1
        Tag.where.not(id: tag.id).where(cleaned_tag: tag.cleaned_tag).each do |t|
          t.taggings.update_all(tag_id: tag.id)
          t.destroy
          out << tag.cleaned_tag
        end
      end
    end
    final_count = Tag.count
    {
      count: count,
      final_count: final_count,
      tags: out
    }
  end

end
