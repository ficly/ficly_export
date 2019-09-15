class TagsController < ApplicationController

  def index
    @page = params[:page].to_i
    @page = 1 if @page < 1
    @tags = Tag.where.not(cleaned_tag: [nil, "", '-']).order('cleaned_tag asc').paginate(page: @page, per_page: 250)
  end

  def stories
    @tag = Tag.find_by(cleaned_tag: params[:id])
    @page = params[:page].to_i
    @page = 1 if @page < 1
    story_ids = @tag.taggings.where(taggable_type: "Story").pluck(:taggable_id)
    @stories = Story.published.where(id: story_ids).order("published_at asc").paginate(page: @page, per_page: 50)
  end

  def challenges
    @tag = Tag.find_by(cleaned_tag: params[:id])
    @page = params[:page].to_i
    @page = 1 if @page < 1
    challenge_ids = @tag.taggings.where(taggable_type: "Challenge").pluck(:taggable_id)
    @stories = Challenge.where(id: challenge_ids).order("id asc").paginate(page: @page, per_page: 50)
  end


end
