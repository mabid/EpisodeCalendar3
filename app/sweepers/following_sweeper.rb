class FollowingSweeper < ActionController::Caching::Sweeper
  observe Following
  
  def after_create(following)
    if following.cached_show.followers >= 10
      expire_fragment("footer_recently_favorited") 
      expire_fragment("footer_tag_cloud")
    end
  end
  
end