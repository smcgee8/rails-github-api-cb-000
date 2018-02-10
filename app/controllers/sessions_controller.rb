class SessionsController < ApplicationController
  skip_before_action :authenticate_user

  def create
    req_params = {
      client_id: ENV['GITHUB_CLIENT_ID'],
      client_secret: ENV['GITHUB_CLIENT_SECRET'],
      code: params[:code],
      redirect_uri: "http://67.205.130.239:57441/auth"
    }
    resp = Faraday.post("https://github.com/login/oauth/access_token") do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.body = req_params.to_json
    end
    session[:token] = JSON.parse(resp.body)["access_token"]

    resp = Faraday.get("https://api.github.com/user") do |req|
      req.headers['Authorization'] = "token #{session[:token]}"
      req.headers['Accept'] = 'application/json'
    end
    session[:username] = JSON.parse(resp.body)["login"]

    redirect_to root_path
  end
end
