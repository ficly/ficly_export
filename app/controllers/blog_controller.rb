class BlogController < ApplicationController

  def index
    @page = params[:page].to_i
    @page = 1 if @page < 1
    @posts = BlogPost.includes(:user, :blog_category).order("created_at desc").paginate(page: @page, per_page: 25)
  end

  def show
    @post = BlogPost.find_by(basename: params[:id])
  end

end
