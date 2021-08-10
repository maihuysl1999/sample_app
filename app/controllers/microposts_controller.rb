class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    if @micropost.save
      flash[:success] = t ".created"
      redirect_to root_url
    else
      flash[:danger] = t ".create_failed"
      @feed_items = load_feed_page current_user, params[:page]
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t ".success_delete"
    else
      flash[:danger] = t ".fail_delete"
    end
    redirect_to request.referer || root_url
  end

  private
  def micropost_params
    params.require(:micropost).permit Micropost::PERMITTED_FIELDS
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t ".invalid"
    redirect_to request.referer || root_url
  end
end
