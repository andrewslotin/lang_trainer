class SessionsController < ApplicationController
  skip_before_filter :authenticate_user!, except: :destroy

  def new
    
  end

  def create
    auth = request.env["omniauth.auth"]
    unless auth
      render json: request.env
      return
    end
    user = User.where("identities.provider" => auth['provider'], "identities.uid" => auth["uid"].to_s).first || User.create_with_omniauth(auth)

    session[:user_id] = user.id
    redirect_to root_url, :notice => 'Signed in!'
  end

  def destroy
    reset_session
    redirect_to root_url, :notice => 'Signed out!'
  end

  def failure
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end
end
