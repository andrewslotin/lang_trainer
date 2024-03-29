class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!
  helper_method :current_user, :user_signed_in?, :correct_user?

  private

  def current_user
    @current_user ||=begin
      User.find(session[:user_id]) if session[:user_id]
    rescue Mongoid::Errors::DocumentNotFound
      nil
    end
  end

  def user_signed_in?
    return true if current_user
  end

  def correct_user?
    @user = User.find(params[:id])
    unless current_user == @user
      redirect_to signin_url, :alert => "Access denied."
    end
  end

  def authenticate_user!
    if !current_user
      redirect_to signin_url, :alert => 'You need to sign in for access to this page.'
    end
  end
end
