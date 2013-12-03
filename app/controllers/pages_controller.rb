class PagesController < ApplicationController
  before_action :signed_in_user

  def home
    render 'about'
  end
end
