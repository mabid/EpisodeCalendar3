class FollowingSweeper < ActionController::Caching::Sweeper
  observe Following
  
  def after_create(following)
    if following.cached_show.followers >= 10
      expire_fragment("footer_recently_favorited") 
      expire_fragment("footer_tag_cloud")
    end
    expire_user_followings(following)
  end

  def after_destroy(following)
  	expire_user_followings(following)
  end

  def expire_user_followings(following)
  	Rails.cache.delete([following.user_id, "followings"])
  end
  
end