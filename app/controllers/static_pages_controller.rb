class StaticPagesController < ApplicationController
  def home
    return unless logged_in?

    @micropost = current_user.microposts.build if logged_in?
    @feed_items = load_feed_page current_user, params[:page]
  end

  def help; end
end
