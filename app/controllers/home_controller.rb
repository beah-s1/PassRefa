class HomeController < ApplicationController
  def index
  
  end
  
  def ekispert_key
    render json:{"ekispert_api_key" => ENV['EKISPERT_API_KEY'].present? ? ENV['EKISPERT_API_KEY']:"", "ekispert_base_url" => ENV['EKISPERT_API_BASEURL'].present? ? ENV['EKISPERT_API_BASEURL']:""}
  end
end
