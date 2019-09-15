class AuthorsController < ApplicationController

  def index
    @page = params[:page].to_i
    @page = 1 if @page < 1
    @authors = User.active.where.not(name: ["", nil], user_is_deleted: true).order("name asc").paginate(page: @page, per_page: 100)
  end

  def show
    @author = User.where(uri_name: params[:id]).includes(:icon, :stories).first
    if @author.nil?
      flash[:alert] = "No author found."
      redirect_to authors_path and return
    end
    @stories = @author.published_stories
    @challenges = @author.challenges
  end

end
