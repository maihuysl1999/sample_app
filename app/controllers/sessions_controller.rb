class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      login user
    else
      flash.now[:danger] = t ".invalid"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  private
  def remember_option user
    log_in user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
    redirect_back_or user
  end

  def login user
    if user.activated?
      remember_option user
    else
      flash[:warning] = t ".required_activate_email"
      redirect_to root_url
    end
  end
end
