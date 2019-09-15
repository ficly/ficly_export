class TagsController < ApplicationController

  def index
    @page = params[:page].to_i
    @page = 1 if @page < 1
    @tags = Tag.where.not(cleaned_tag: [nil, "", '-']).where("stories_count > 0").order('stories_count desc, cleaned_tag asc').paginate(page: @page, per_page: 250)
  end

  def show
    @tag = Tag.find_by(cleaned_tag: params[:id])
    story_ids = @tag.taggings.where(taggable_type: "Story").pluck(:taggable_id)
    @stories = Story.published.where(id: story_ids).order("published_at asc").paginate(page: 1, per_page: 50)
    # challenge_ids = @tag.taggings.where(taggable_type: "Challenge").pluck(:taggable_id)
    # @challenges = Challenge.where(id: challenge_ids).order("id asc").paginate(page: 1, per_page: 50)
  end

  def stories
    @tag = Tag.find_by(cleaned_tag: params[:id])
    @page = params[:page].to_i
    @page = 1 if @page < 1
    story_ids = @tag.taggings.where(taggable_type: "Story").pluck(:taggable_id)
    @stories = Story.published.where(id: story_ids).order("published_at asc").paginate(page: @page, per_page: 50)
  end
  #
  # def challenges
  #   @tag = Tag.find_by(cleaned_tag: params[:id])
  #   @page = params[:page].to_i
  #   @page = 1 if @page < 1
  #   challenge_ids = @tag.taggings.where(taggable_type: "Challenge").pluck(:taggable_id)
  #   @challenges = Challenge.where(id: challenge_ids).order("id asc").paginate(page: @page, per_page: 50)
  # end


end
