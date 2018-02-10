class RepositoriesController < ApplicationController
  def index
    resp = Faraday.get("https://api.github.com/user/repos") do |req|
      req.headers['Authorization'] = "token #{session[:token]}"
      req.headers['Accept'] = 'application/json'
      req.params["sort"] = "created"
    end
    @repos = JSON.parse(resp.body)
  end

  def create
    Faraday.post("https://api.github.com/user/repos") do |req|
      req.headers['Authorization'] = "token #{session[:token]}"
      req.headers['Content-Type'] = 'application/json'
      req.body = {name: params[:name]}.to_json
    end
    redirect_to root_path
  end
end
