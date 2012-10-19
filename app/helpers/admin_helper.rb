module AdminHelper
  
  def system_status(date, interval, override = false)
    if date > Time.now-interval || override
      image_tag("icons/big/standby.png")
    else
      image_tag("icons/big/shutdown.png")
    end
  end
  
end