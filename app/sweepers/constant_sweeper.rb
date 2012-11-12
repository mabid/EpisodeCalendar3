class ConstantSweeper < ActionController::Caching::Sweeper
  observe Constant
  
  def after_update(constant)
    Rails.cache.delete("system_message") if constant.key == "system_message"
  end
  
end