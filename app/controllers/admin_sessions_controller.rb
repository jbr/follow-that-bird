class AdminSessionsController < ApplicationController
  admin :denied
  
  def create
    password = params[:admin_session][:password]
    if password == AppConfig.admin_password
      session[:admin_password] = password
      redirect_to root_url
    else
      flash[:notice] = "Incorrect password"
      redirect_to new_admin_session_url
    end
  end
end