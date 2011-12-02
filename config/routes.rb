Episodecalendar2::Application.routes.draw do

  #Active admin
  ActiveAdmin.routes(self)
  
  #Devise
  devise_for :admin_users, ActiveAdmin::Devise.config
	devise_for :users, :path => "account"
	
  resources :tickets
  resources :seen_episodes, :as => "unwatched"
  resources :hidden_episodesr
  resources :banners
	resources :followings, :path => "my-shows"
	resources :episodes
	resources :shows
	resources :users
  resources :faqs, :path => "faq" do
    collection { post :sort }
  end
	
	#Pages
	match "/info" => "support#index"
  match "/settings" => "users#settings"
  match "/top-shows" => "shows#top_shows", :as => "top_shows"
  match "/trends" => "shows#trends"
  
  #User links
  match "/profile/:id" => "users#show", :as => "profile", :constraints => { :id => /.*/} #This regex breaks ajax calls
  match "/ical_feed/:id" => "users#ical", :as => "ical", :constraints => { :id => /.*/} #This regex breaks ajax calls
  match "/rss_feed/:id" => "users#rss", :as => "rss", :constraints => { :id => /.*/} #This regex breaks ajax calls

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

	match "/mark_episode/:episode_id/:season_id" => "seen_episodes#mark_episode", :as => "mark_episode"
	match "/show/:show_id/mark-season/:season_id" => "seen_episodes#mark_season", :as => "mark_season"
	match "/show/:show_id/unmark-season/:season_id" => "seen_episodes#unmark_season", :as => "unmark_season"
	match "/show/:show_id/mark" => "seen_episodes#mark_show", :as => "mark_show"

  match "/hide_episode/:episode_id/:season_id" => "hidden_episodes#hide_episode", :as => "hide_episode"

  match "/render_progress" => "followings#render_progress"
  match "/facebook_button/:id" => "shows#facebook_button"
  match "/unwatched" => "seen_episodes#index", :as => "unwatched"
  match "/get_unwatched_episodes/:show_id" => "seen_episodes#unwatched_episodes", :format => "js", :as => "get_unwatched_episodes"
  match "/show/:show_id/watch_later/:mark" => "followings#set_watch_later", :as => "set_watch_later"
  
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
