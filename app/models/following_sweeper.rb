class FollowingSweeper < ActionController::Caching::Sweeper
  observe Following
  
  def after_create(following)
    expire_fragment("footer")
  end
  
end 