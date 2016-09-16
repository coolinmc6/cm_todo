Rails.application.routes.draw do
  get 'pages/home'

  get 'pages/about'

  get 'pages/contact'

  devise_for :users
  resources :todo_lists do
  	resources :todo_items
  end

  authenticated :user do
  	root 'todo_lists#index', as: "authenticated_root"
  end

  root 'pages#home'


  # The code below is from Mackenzie's Notebook app:
	  # authenticated :user do
	  # 	root 'notes#index', as: "authenticated_root"  	
	  # end

	 	# root 'welcome#index'
end
