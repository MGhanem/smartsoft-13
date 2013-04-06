Arability::Application.routes.draw do
  root :to => 'pages#home'

  get "admin/index"

  get "admin/login"
  get "admin/logout"

  post "admin/login"
  post "admin/wordadd"

  match '/auth/google' => 'services#create'
  match '/auth/google/login' => 'services#index' 
  resources :services, :only => [:index, :create, :destroy]
  
  resources :projects
  get "projects/update"

  get "admin/import_csv"

  post "admin/upload"

  scope "/developers" do
    resources :projects

    match "keywords/new" => "keywords#new"

    match "keywords/suggest_add" => "keywords#suggest_add"

    match "keywords/create" => "keywords#create"

    match '/developers/new' => "developer#new"
    match '/developers/create' => "developer#create"
    match '/my_subscriptions/new' => "my_subscription#new"
    match '/my_subscriptions/create' => "my_subscription#create"

    match 'search' => 'search#search'

    match 'follow' => 'follow#follow', :as => "list_followed_words"
  end

  # required for routing by the devise module(gem)
  devise_for :gamers do get '/gamers/sign_out' => 'devise/sessions#destroy' end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "admin#import_csv"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
