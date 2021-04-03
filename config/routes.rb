Rails.application.routes.draw do
  devise_for :users, :only => []
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/', to: 'home#index'
  
  scope :api do
    get 'health', to: 'application#health_check'
    get '/ekispert-key', to: 'home#ekispert_key'
  end
  
  scope :auth do
    get '/', to: 'auth#auth'
    get '/callback', to: 'auth#callback'
  end
end
