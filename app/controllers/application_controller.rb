class ApplicationController < ActionController::Base
  include InheritedResources::DSL

  helper :all
  protect_from_forgery
  
  def admin_required
    admin? or access_denied
  end

  def admin_denied
    redirect_to root_url and return false if admin?
  end
  
  def self.admin(action, options = {})
    case action
    when :required
      before_filter :admin_required, options
    when :denied
      before_filter :admin_denied, options
    end
  end
  
  def access_denied
    redirect_to new_admin_session_url and return false
  end
  
  def admin?
    session[:admin_password] == AppConfig.admin_password
  end
  
  protected
  
  def tweet_ids_voted_on
    session[:tweet_ids_voted_on] ||= []
  end
  
end
