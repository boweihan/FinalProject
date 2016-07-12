class SessionsController < ApplicationController
  def new
    # render :layout => false
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      Message.api
      redirect_to contacts_url, notice: "Thanks for logging in!"
    else
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to new_session_url, notice: "You have logged out."
  end


end
