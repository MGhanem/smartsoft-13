Arability::Application.routes.draw do

  
  root :to => 'pages#home'
  
  match '/game' => 'games#game'

  resources :projects
  resources :developer

  get "developer/index"
  
  get "admin/index"


  post "games/vote" 


  post "games/record_vote"

  post "admin/login"
  post "admin/wordadd"
  
  resources :projects
  match "projects/share/:id" => "projects#share"
  match "projects/share_project_with_developer" => "projects#share_project_with_developer", :via => :post


  get 'games/getnewwords'


  scope "(:locale)", :locale => /en|ar/ do
    #here only two languages are accepted: english and arabic

    get "admin/index"

    get "admin/login"
    get "admin/logout"

    post "admin/login"

    get "admin/import_csv"

    post "admin/upload"

    post "admin/addword"
    post "admin/addtrophy"
    post "admin/addprize"

    get "admin/deletetrophy"
    get "admin/deleteprize"

    match '/game' => 'games#game'
    # required for routing by the devise module(gem)
    devise_for :gamers do
       get '/gamers/sign_out' => 'devise/sessions#destroy'
    end

 
  get "projects/remove_developer_from_project"
  match "projects/share/:id" => "projects#share"
  match "projects/share_project_with_developer" => "projects#share_project_with_developer", :via => :put
  post "keywords/create"


  

  match '/developers/new' => "developer#new"
  match '/developers/create' => "developer#create"
  match '/my_subscriptions/new' => "my_subscription#new"
  match '/my_subscriptions/create' => "my_subscription#create"
  match '/my_subscriptions/choose_sub' => "my_subscription#choose_sub"
  match '/my_subscriptions/pick' => "my_subscription#pick"
  



    # devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }


    scope "developers/" do 

      match "follow/:keyword_id" => "follow#follow", :as => "follow_word"

      match "unfollow/:keyword_id" => "follow#unfollow", :as => "unfollow_word"

      match "followed" => "follow#list_followed", :as => "list_followed_words"

      get "keywords/new"
      match "keywords" => "keywords#viewall"
      match "keywords/new" => "keywords#new"
      match "keywords/create" => "keywords#create"
      post "keywords/create"


      get "keywords/suggest_add" => "keywords#suggest_add"

      
      get "projects/update"
     
     
      match 'search' => 'search#search'

      match 'follow' => 'follow#follow', :as => "list_followed_words"

    end
  end

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
