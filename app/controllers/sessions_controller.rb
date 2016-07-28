class SessionsController < ApplicationController

  #signin form
  def new
    # render :layout => false
  end

  #on login
  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      # redirect_to '/googleauth', notice: "Thanks for logging in!"
      redirect_to '/login_page'
    else
      render :new
    end
  end

  #on logout
  def destroy
    session[:user_id] = nil
    redirect_to new_session_url, notice: "You have logged out."
  end


end
