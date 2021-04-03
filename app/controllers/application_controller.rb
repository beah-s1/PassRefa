require 'devise'
class ApplicationController < ActionController::Base
  include Devise::Controllers::SignInOut
  
  def check_api_access
    if signed_in?
      return
    end
    
    render plain: "you have to sign in", status: 403
  end
  
  def check_sign_in_status
    if signed_in?
      return
    end
    
    redirect_to "/auth"
  end
  
  helper_method :check_sign_in_status
  helper_method :check_api_access
end
