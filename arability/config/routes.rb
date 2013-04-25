Arability::Application.routes.draw do

  root :to => 'pages#home'

  scope "/admin" do 
    get "/login"
    get "/logout"
    get "/index"
    get "/import_csv"
    get "/delete_trophy"
    get "/delete_prize"

    post "/login"
    post "/upload"
    post "/add_word"
    post "/add_trophy"
    post "/add_prize"
  end

  # Only two languages are accepted: Arabic and English
  scope "(:locale)", :locale => /en|ar/ do

    # required for routing by the devise module(gem)

    devise_for :gamers do 
      get '/gamers/sign_out' => 'devise/sessions#destroy'
      match "/social_registrations/new_social" => "social_registrations#new_social"
      post "/social_registrations/social_sign_in"
      post "/gamers" => "social_registrations#update"
    end

    match '/game' => 'games#game'
    post "games/vote" 
    post "games/record_vote"
    get 'games/getnewwords'
    get "games/getprizes"
    post "games/vote_errors"
    post "games/record_synonym"
    get 'games/gettrophies'
    get 'games/getnewwords'
    get "games/showprizes"
    get "games/get_score_only"
    post "games/record_synonym"
    get "/games/halloffame"

    match "/share_on_facebook"=>'games#post_score_facebook', :as => "share_on_facebook"
    get "/games/disconnect_facebook"
    match '/authentications/facebook_connect' => 'authentications#facebook_connect'
    get "authentications/remove_twitter_connection"
    match '/auth/twitter/callback', :to => 'authentications#twitter_callback' 
    match '/tweet/tweet_invitation' => "tweet#tweet_invitation"
    match '/tweet/tweet_score' => "tweet#tweet_score"
    match '/auth/failure', :to => 'authentications#callback_failure'
    match "/post_score"=>'games#post', :as => "post_facebook"
    match '/auth/facebook/callback' => 'authentications#facebook_callback'

    scope "developers/" do 
      match "/" => "backend#home", :as => "backend_home"

      get "projects/remove_developer_from_project"
      match "projects/share/:id" => "projects#share", :as => "share_project"
      match "projects/share_project_with_developer" => "projects#share_project_with_developer", :via => :put
      get "projects/update"
      get "projects/remove_developer_from_project"
      put '/projects/:id/add_from_csv_keywords' => "projects#add_from_csv_keywords", :as => :add_from_csv_keywords_project
      match "/projects/upload" => "projects#upload", :as => :upload_csv_project
      match "/projects/:project_id/add_word" => "projects#add_word", :as => "projects_add_word"
      match '/projects/:project_id/remove_word' => "projects#remove_word", :as => "projects_remove_word"
      match '/projects/:project_id/export_csv' => "projects#export_to_csv", :as => "projects_export"
      match '/projects/:id/import_csv' => "projects#import_csv", :as => :import_csv_project
      match '/projects/:id/choose_keywords' => "projects#choose_keywords", :as => :choose_keywords_project
      resources :projects

      match '/my_subscriptions/choose_sub' => "my_subscription#choose_sub", :as => :choose_sub
      match '/my_subscriptions/pick' => "my_subscription#pick"
      match '/my_subscriptions/new' => "my_subscription#new"
      match '/my_subscriptions/create' => "my_subscription#create"

      match "follow/:keyword_id" => "follow#follow", :as => "follow_word"
      match "unfollow/:keyword_id" => "follow#unfollow", :as => "unfollow_word"
      match "followed" => "follow#list_followed", :as => "list_followed_words"

      match "keywords/create" => "keywords#create", :as => :keywords_create
      match "keywords/new" => "keywords#new", :as => :keywords_new
      match "keywords" => "keywords#viewall"

      match 'search' => 'search#search'

      match 'search_keywords' => 'search#search_keywords'

      match '/developers/new' => "developer#new"
      match '/developers/create' => "developer#create"
    end
  end

  get "/en/gamers" => redirect('/en/gamers/sign_up')

  get "/ar/gamers" => redirect('/ar/gamers/sign_up')

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
