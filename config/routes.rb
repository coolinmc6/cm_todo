Rails.application.routes.draw do
  devise_for :users
  resources :todo_lists do
  	resources :todo_items
  end
  
  root "todo_lists#index"
end
