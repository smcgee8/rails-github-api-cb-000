class SessionsController < ApplicationController
  skip_before_action :authenticate_user

  def create
    resp = Faraday.post("https://github.com/login/oauth/access_token") do |req|
      req.body = "{
        client_id: #{ENV['GITHUB_CLIENT_ID']},
        client_secret: #{ENV['GITHUB_CLIENT_SECRET']},
        code: #{params[:code]},
        redirect_uri: #{"http://67.205.130.239:57441/auth"}
      }"
    end
    body = JSON.parse(resp.body)
    session[:token] = body["access_token"]
    binding.pry
    redirect_to root_path
  end
end
