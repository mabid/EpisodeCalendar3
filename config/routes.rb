Episodecalendar2::Application.routes.draw do

  ActiveAdmin.routes(self)

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  
  #Devise
  devise_for :admin_users, ActiveAdmin::Devise.config
	devise_for :users, :path => "account"
	
  resources :tickets
  resources :seen_episodes, :as => "unwatched"
  resources :banners
	resources :followings, :path => "my-shows"
	resources :episodes
	resources :shows
	resources :users
	
	#Pages
	match "/info" => "support#index"
	match "/faq" => "support#faq"
  match "/settings" => "users#settings"
  match "/top-shows" => "shows#top_shows", :as => "top_shows"
  match "/trends" => "shows#trends"
  
  #User links
  match "/profile/:id" => "users#show", :as => "profile", :constraints => { :id => /.*/} #This regex breaks ajax calls
  match "/ical_feed/:id" => "users#ical", :as => "ical_feed", :constraints => { :id => /.*/} #This regex breaks ajax calls
  match "/rss_feed/:id" => "users#rss", :as => "rss_feed", :constraints => { :id => /.*/} #This regex breaks ajax calls

  #Calendar
	match "/calendar" => "shows#calendar"  
  match "/calendar/:year/:month" => "shows#calendar",	:year => /\d{4}/, :month => /\d{1,2}/
	match "/public" => "shows#public"
  match "/public/:year/:month" => "shows#public",	:year => /\d{4}/, :month => /\d{1,2}/, :as => "public_with_date"
	match "/icalendar/:email/:auth_key" => "shows#calendar_iframe", :as => "icalendar", :constraints => { :email => /.*/} #This regex breaks ajax calls
	
	#Show
	match "/show/:permalink" => "shows#show", :as => "show"
	match "/show/:permalink/season/:season" => "shows#show", :as => "show_season"
	match "/add-show/:permalink" => "followings#create", :as => "add_show"
	match "/mark_episode/:episode" => "seen_episodes#mark_episode"
	match "/show/:show_id/mark-season/:season_id" => "seen_episodes#mark_season", :as => "mark_season"
	match "/show/:show_id/unmark-season/:season_id" => "seen_episodes#unmark_season", :as => "unmark_season"
	match "/show/:show_id/mark" => "seen_episodes#mark_show", :as => "mark_show"
  match "/render_progress" => "followings#render_progress"
  match "/facebook_button/:id" => "shows#facebook_button"
  match "/unwatched" => "seen_episodes#index", :as => "unwatched"
  match "/get_unwatched_episodes/:show_id" => "seen_episodes#unwatched_episodes", :format => "js", :as => "get_unwatched_episodes"
  
  #Support
  match "/request-show/" => "support#request_show", :as => "request_show"
  match "/request-show/:show_id/:show_name" => "support#queue_requested_show", :as => "queue_requested_show"
  match "/request-successful/:permalink" => "support#request_successful", :as => "request_successful"
  
  #Browsing
  match "/users/letter/:letter" => "users#index", :as => "users_by_letter"
  match "/shows/letter/:letter" => "shows#index", :as => "shows_by_letter"
  
  #Misc
	match "/search" => "shows#search"
  match "/set-format/:show_format/:episode_format" => "users#set_format", :show_format => /\d{1}/, :episode_format => /\d{1}/
  match "/sitemap" => "support#sitemap", :format => "rxml"
  match "/statistics" => redirect("/")

	#Mobile
	match "/:platform/auth/:email/:password.:format" => "mobile#authenticate", :constraints => { :platform => /android|iphone|wp7|air/, :email => /.*/}
	match "/:platform/rss_feed/:email/:auth_key.:format" => "mobile#rss", :constraints => { :platform => /android|iphone|wp7|air/, :email => /.*/}
  match "/:platform/check_off/:episode_id/:value/:email/:auth_key.:format" => "mobile#check_off", :constraints => { :platform => /android|iphone|wp7|air/, :email => /.*/}
  
	root :to => "start#index"
  match ':controller(/:action(/:id(.:format)))'
end
