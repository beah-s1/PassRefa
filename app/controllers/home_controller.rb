class HomeController < ApplicationController
  before_action :check_sign_in_status, only: [:index]
  before_action :check_api_access, only: [:ekispert_key]
  
  def index
    check_sign_in_status
  end
  
  def ekispert_key
    render json:{"ekispert_api_key" => ENV['EKISPERT_API_KEY'].present? ? ENV['EKISPERT_API_KEY']:"", "ekispert_base_url" => ENV['EKISPERT_API_BASEURL'].present? ? ENV['EKISPERT_API_BASEURL']:""}
  end
end
