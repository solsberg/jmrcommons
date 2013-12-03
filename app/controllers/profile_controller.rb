require 'profile'

class ProfileController < ApplicationController
  before_action :correct_user,   only: [:update]

  def show
    user = User.find(params[:user_id])
    @profile = JMRCommons::Profile.new user
    if current_user? user
      render 'edit'
    end
  end

  def update
    user = User.find(params[:user_id])
    @profile = JMRCommons::Profile.new user
    @profile.update params
    user.reload
    render 'edit'
  end

private

  def correct_user
    @user = User.find(params[:user_id])
    redirect_to root_url unless current_user? @user
  end

end
