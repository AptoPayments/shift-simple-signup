class UsersController < ApplicationController

  def index
    redirect_uri = 'http://4ddf95d8.ngrok.com/oauth_return'
    Dwolla::scope = 'send|accountinfofull|funding|transactions'
    @dwolla_link = Dwolla::OAuth.get_auth_url(redirect_uri)
    #@dwolla_link = "https://uat.dwolla.com/oauth/v2/authenticate?client_id=#{URI.encode(@client_id)}&response_type=code&redirect_uri=#{URI.encode(@redirect_uri)}&scope=#{@scope}&verified_account=true"
  end

  def oauth_return
    if params[:error]
      render :index
      return
    end

    Dwolla::token = finalize_oauth(params['code'])
    user = Dwolla::Users.get
    name = user['Name'].split(' ')
    @user = User.new(
      first_name: name.first,
      last_name: name.last,
      city: user['City'],
      state: user['State']
    )

    render :new
  end

  def new
    @user = params[:user] || User.new
  end

  def create
    @user = params[:user]
  end

  private

    def finalize_oauth(code)
      oauth = Dwolla::OAuth.get_token(code)
      session[:refresh_token] = oauth['refresh_token']
      session[:token] = oauth['access_token']
    end

end
