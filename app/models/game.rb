class Game < ActiveRecord::Base
	belongs_to :away_team, :class_name => 'Team'
	belongs_to :home_team, :class_name => 'Team'
	def url
		return self.home_team.game_abbr + self.year + self.month + self.day + self.num
	end
end
