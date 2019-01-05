class ChallengesController < ApplicationController

  def index
    @page = params[:page].to_i
    @page = 1 if @page < 1

    @challenges = Challenge.includes(:user).paginate(page: @page, per_page: 50)
  end

  def show
    @challenge = Challenge.find(params[:id])
  end

end
