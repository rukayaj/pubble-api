Rails.application.routes.draw do
  resources :books do
    resources :artworks
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'auth/login', to: 'users#login'
  
end
