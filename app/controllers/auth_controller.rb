require 'devise'
require 'open-uri'
require 'json'
require 'uri'
require 'net/http'
class AuthController < ApplicationController
  def auth
    oidc_configuration = JSON.parse(open(ENV['OIDC_CONFIGURATION_URL']).read)
    
    # リダイレクト用URLの組み立て
    url = "#{oidc_configuration["authorization_endpoint"]}?client_id=#{ENV['OIDC_CLIENT_ID']}&redirect_uri=#{ENV['SERVER_HOST']}/auth/callback&scope=openid profile email&response_type=code"
    redirect_to(url)
  end
  
  def callback
    oidc_configuration = JSON.parse(open(ENV['OIDC_CONFIGURATION_URL']).read)
    
    token_url = URI.parse(oidc_configuration["token_endpoint"])
    
    req = Net::HTTP::Post.new(token_url.path)
    req.set_form_data({
                        "code" => params["code"],
                        "client_id" => ENV['OIDC_CLIENT_ID'],
                        "client_secret" => ENV['OIDC_CLIENT_SECRET'],
                        "grant_type" => "authorization_code",
                        "scope" => "openid profile email",
                        "redirect_uri" => "#{ENV['SERVER_HOST']}/auth/callback"
                      })
    
    response = Net::HTTP.start(token_url.host, token_url.port, :use_ssl => token_url.scheme == "https") do |http|
      http.request(req)
    end
    
    response_dict = JSON.parse(response)
    id_token = response_dict['id_token']
  end
end
