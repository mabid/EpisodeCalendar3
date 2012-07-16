class FollowingSweeper < ActionController::Caching::Sweeper
  observe Following
  
  def after_create(following)
    expire_fragment("footer") if following.show.followers >= 10
  end
  
end