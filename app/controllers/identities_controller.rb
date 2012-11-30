class IdentitiesController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:new, :create]

  def new
    @identity = env["omniauth.identity"] || {}
  end

  def create
    user = if user_signed_in?
             current_user
           else
             User.new(name: params[:name], email: params[:email])
           end


    identity = Identities::Common(provider:              :identity,
                                  email:                 params[:email],
                                  password:              params[:password],
                                  password_confirmation: params[:password])
    user.identities << identity

    if user.save
      session[:user_id] = user._id
      identity.update_attribute(:uid, identity.uid)
      redirect_to dictionaries_path
    else
      @identity = params
      render "new"
    end
  end
end
