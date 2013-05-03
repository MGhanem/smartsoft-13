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

    match "" => "admin#index", :via => [:get]
    scope "/add" do
      match "/word" => "admin#add_word", :via => [:get, :post]
      match "/trophy" => "admin#add_trophy", :via => [:get, :post]
      match "/prize" => "admin#add_prize", :via => [:get, :post]
    end
    scope "/list" do
      match "/trophies" => "admin#list_trophies", :via => [:get]
      match "/prizes" => "admin#list_prizes", :via => [:get]
      match "/gamers" => "admin#list_gamers", :via => [:get]
      match "/developers" => "admin#list_developers", :via => [:get]
      match "/admins" => "admin#list_admins", :via => [:get]
      match "/projects" => "admin#list_projects", :via => [:get]
    end
    scope "/delete" do
      match "/trophy" => "admin#delete_trophy", :via => [:get]
      match "/prize" => "admin#delete_prize", :via => [:get]
    end
    scope "/import" do
      match "/csvfile" => "admin#upload", :via => [:get, :post]
    end
    match "/make_admin" => "admin#make_admin", :via => [:get]
    match "/remove_admin" => "admin#remove_admin", :via => [:get]
    match "/add_category" => "admin#add_category"
    match "/view_categories" => "admin#view_categories"
    match "/delete_category"=>"admin#delete_category", :as => "delete_category"
    match "/ignore_report"=>"admin#ignore_report", :as => "ignore_report"
    match "/unapprove_word"=>"admin#unapprove_word", :as => "unapprove_word"
    match "/view_reports" => "admin#view_reports"
    match "/view_subscription_models" => "admin#view_subscription_models"
    match "/:model_id/edit_subscription_model"=>"admin#edit_subscription_model", :as => "edit_subscription_model"
    put "/:model_id/update_subscription_model" => "admin#update_subscription_model", :as => "update_model"
    resources :subscription_models
  end

  # Only two languages are accepted: Arabic and English
  scope "(:locale)", :locale => /en|ar/ do

    # required for routing by the devise module(gem)

    # devise_for :gamers, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }
    devise_for :gamers
    devise_for :gamers do
      get '/gamers/sign_out' => 'devise/sessions#destroy'
      match "/social_registrations/new_social" => "social_registrations#new_social"
      post "/social_registrations/social_sign_in"
      get "/gamers/sign_in" => "devise/sessions#new"
      post "/gamers/confirmation" => "devise/confirmations#create"
      get "/gamers/confirmation/new" => "devise/confirmations#new", :as => "new_confirmation"
      get "/gamers/confirmation" => "devise/confirmations#show"
    end

    match '/game' => 'games#game'
    post "games/vote"
    post "games/record_vote"
    get 'games/getnewwords'
    get "games/get_prizes"
    post "games/vote_errors"
    post "games/record_synonym"
    get 'games/get_trophies'
    get 'games/getnewwords'
    get "games/show_trophies"
    get "games/show_prizes"
    get "games/get_score_only"
    post "games/record_synonym"
    get "/games/halloffame"
    get "games/disableTutorial"
    get "games/showprofile"

    match "/share_on_facebook"=>'games#post_score_facebook', :as => "share_on_facebook"
    get "/games/disconnect_facebook"
    match '/authentications/facebook_connect' => 'authentications#facebook_connect'
    get "authentications/remove_connection"
    match '/auth/twitter/callback', :to => 'authentications#twitter_callback'
    match '/tweet/tweet_invitation' => "tweet#tweet_invitation"
    match '/tweet/tweet_score' => "tweet#tweet_score"
    match '/auth/failure', :to => 'authentications#callback_failure'
    match "/post_score"=>'games#post', :as => "post_facebook"
    match "guest/sign_up" => "guest#sign_up", as: "guest_sign_up"
    post "guest/signing_up" => "guest#signing_up", :as => "guest_signing_up"
    match "guest/continue_sign_up" => "guest#continue_sign_up", as: "guest_continue_sign_up"
    post "guest/continue_signing_up" => "guest#continue_signing_up", :as => "guest_continue_signing_up"
    match '/auth/facebook/callback' => 'authentications#facebook_callback'
    match "/games/post_facebook" => "games#post"

    scope "developers/" do
      match "/" => "backend#home", :as => "backend_home"
      match "projects/remove_developer_from_project" => "developer#remove_developer_from_project"
      get "projects/remove_developer_from_project"
      match "/auth/google_oauth2/callback" => "authentications#google_callback"

      get "projects/remove_developer_from_project"
      match "projects/:id/share" => "projects#share", :as => "share_project"
      match "projects/share_project_with_developer" => "developer#share_project_with_developer", :via => :put
      match "projects/remove_project_from_developer" => "projects#remove_project_from_developer", :via => :get , :as => :remove
      match "/projects/:id/destroy" => "projects#destroy", :as => :delete
      put "projects/destroy"
      resources :projects

      match 'projects' => "projects#index", :as => :projects
      match "/" => "backend#home", :as => "backend_home"

      get "projects/remove_developer_from_project"

      get "projects/update"

      put '/projects/:id/add_from_csv_keywords' => "projects#add_from_csv_keywords", :as => :add_from_csv_keywords_project
      match "/projects/upload" => "projects#upload", :as => :upload_csv_project
      match '/projects/:project_id/:word_id/remove_word' => "projects#remove_word", :as => "projects_remove_word"
      match '/projects/:project_id/export_csv' => "projects#export_to_csv", :as => "projects_export_csv"
      match '/projects/:id/import_csv' => "projects#import_csv", :as => :import_csv_project
      match '/projects/:id/choose_keywords' => "projects#choose_keywords", :as => :choose_keywords_project



      match '/projects/:project_id/export_xml' => "projects#export_to_xml", :as => "projects_export_xml"
      match '/projects/:project_id/export_json' => "projects#export_to_json", :as => "projects_export_json"



      match '/my_subscriptions/choose_sub' => "my_subscription#choose_sub", :as => :choose_sub
      match '/my_subscriptions/pick' => "my_subscription#pick"
      match '/my_subscriptions/pick_edit' => "my_subscription#pick_edit"
      match '/my_subscriptions/new' => "my_subscription#new"
      match '/my_subscriptions/create' => "my_subscription#create"

      match "follow/:keyword_id" => "follow#follow", :as => "follow_word"
      match "unfollow/:keyword_id" => "follow#unfollow", :as => "unfollow_word"
      match "followed" => "follow#list_followed", :as => "list_followed_words"

      match "keywords/create" => "keywords#create", :as => :keywords_create
      match "keywords/new" => "keywords#new", :as => :keywords_new
      match "keywords" => "keywords#viewall"

      match "search" => "search#search_with_filters"

      match "search_keywords" => "search#search_keywords"

      match "send_report" => "search#send_report"

      match "search_with_filters" => "search#search_with_filters"

      match "autocomplete" => "search#keyword_autocomplete"

      match '/developers/new' => "developer#new"
      match '/developers/create' => "developer#create"
    end
  end

  get "gamers/sign_in" => redirect("/en/gamers/sign_in")
  get "gamers/sign_in" => redirect("/ar/gamers/sign_in")

  get "gamers/gamers/confirmation/new" => redirect("/en/gamers/confirmation/new")
  get "gamers/gamers/confirmation/new" => redirect("/ar/gamers/confirmation/new")


  get "/en/gamers/password" => redirect("/en/gamers/password/edit")

  get "/ar/gamers/password" => redirect("/ar/gamers/password/edit")

  get "/en/gamers" => redirect('/en/gamers/sign_up')

  get "/ar/gamers" => redirect('/ar/gamers/sign_up')

  match "/developers/projects/:project_id/change_synonym" => "projects#change_synonym", :as => "change_synonym"

  match "/developers/projects/:project_id/quick_add" => "projects#quick_add", :as => "quick_add"

  match "/developers/projects/load_synonyms" => "projects#load_synonyms"

  match "developers/projects/:project_id/project_keyword_autocomplete" => "projects#project_keyword_autocomplete"

  match "/developers/projects/:project_id/add_word_inside_project" => "projects#add_word_inside_project", as: "add_word_inside_project"

  match "/developers/projects/:project_id/test_followed_keyword" => "projects#test_followed_keyword"

  match "/developers/projects/:project_id/follow_unfollow" => "projects#follow_unfollow", :as => "follow_unfollow"

  match "*path", :to => "application#routing_error"

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
