module EpisodesHelper
	
	def format_episode_number(episode, user = current_user)
		f = (user.nil? ? 2 : user.episode_format)
		episode.format(f)
	end
	
	def round(int, round_to)
		mod = int % round_to
		rounded = int - mod + (mod >= round_to/2.0 ? round_to : 0)
		return rounded % 1 == 0 ? rounded.to_i : rounded
	end
	
	def get_rating(rating)
	  return "0" unless rating
	  return round(rating.to_f, 0.5).to_s.gsub(".", "")
  end
	
end