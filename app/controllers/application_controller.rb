class ApplicationController < ActionController::Base
  include SessionsHelper
  include MicropostsHelper

  before_action :set_locale

  rescue_from ActiveRecord::RecordNotFound, with: :deny_access

  protected
  def deny_access
    flash[:danger] = t ".user_not_found"
    redirect_to root_path
  end

  private
  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    check = I18n.available_locales.include?(locale)
    I18n.locale = check ? locale : I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "please_log_in."
    redirect_to login_url
  end
end
