class UsersController < ApplicationController

  def index
    scope = 'send|accountinfofull|funding|transactions'
    @dwolla_link = Dwolla::OAuth.get_auth_url(@redirect_uri, scope, true)
  end

  def oauth_return
    if params[:error] || !params[:code]
      redirect_to root_path
      return
    end

    oauth = Dwolla::OAuth.get_token(params['code'], @redirect_uri)
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
  end

  def create
    @user = User.new(params[:user])

    if @user.valid?
      @user.token = session[:token]
      @user.refresh_token = session[:refresh_token]

      if @user.create()
        puts "[SUCCESS]: #{@user.email}"
        session.delete(:token)
        session.delete(:refresh_token)
        render :show
      else
        @error = @user.response['error']['message'] || @user.response['errors'].first['message']
        render :new
      end

    else
      @error = @user.errors.full_messages.first
      render :new
    end
  end

end
