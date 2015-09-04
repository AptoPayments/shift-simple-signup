class UsersController < ApplicationController

  def index
    redirect_uri = url_for(:oauth_return)
    scope = 'send|accountinfofull|funding|transactions'
    @dwolla_link = Dwolla::OAuth.get_auth_url(redirect_uri, scope, true)
  end

  def oauth_return
    if params[:error] || !params[:code]
      render :index
      return
    end

    oauth = Dwolla::OAuth.get_token(params['code'])
    session[:token] = oauth['access_token']
    session[:refresh_token] = oauth['refresh_token']
    redirect_to new_user_path
  end

  def new
    @user = User.new
    if Dwolla::token = session[:token]
      user = Dwolla::Users.get
      name = user['Name'].split(' ')
      @user.first_name = name.first
      @user.last_name = name.last
      @user.city = user['City']
      @user.state = user['State']
    end
  rescue Dwolla::APIError
  end

  def create
    @user = User.new(params[:user])
    @user.token = session[:token]
    @user.refresh_token = session[:refresh_token]

    if @user.create
      render :show
    else
      @error = @user.response['error']['message']
      render :new
    end
  end

end
