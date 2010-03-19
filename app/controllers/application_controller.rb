class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user

  protected

  before_filter do |c|
    puts c.current_user.inspect
    Authorization.current_user = c.current_user
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def permission_denied
    flash[:error] = "Sorry, you are not allowed to access that page."
    redirect_to root_url
  end
end
