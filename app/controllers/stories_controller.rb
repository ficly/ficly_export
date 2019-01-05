class StoriesController < ApplicationController

  def index
    @page = params[:page].to_i
    @page = 1 if @page < 1

    @stories = Story.published.includes(:user).paginate(page: @page, per_page: 100)
    @total_pages = @stories.total_pages
  end

  def show
    @story = Story.includes(:taggings).find(params[:id])
    @user = @story.user
    @tags = @story.tags
    @sequels = @story.sequels.includes(:user)
    @prequels = @story.prequels.includes(:user)
  end

  def comments
    @story = Story.includes(:taggings).find(params[:id])
    @comments = @story.comments.includes(:user).order("id asc")
  end

end
