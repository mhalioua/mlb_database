class Hitter < ActiveRecord::Base
	belongs_to :team
	belongs_to :game
end
