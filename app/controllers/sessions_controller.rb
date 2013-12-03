class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(name: params[:username].downcase)
    if user && user.authenticate(params[:password])
      sign_in user
      redirect_back_or root_path
    else
      if user.nil?
        flash.now[:error] = "An account could not be found for that username."
      else
        flash.now[:error] = "Incorrect password."
      end
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end