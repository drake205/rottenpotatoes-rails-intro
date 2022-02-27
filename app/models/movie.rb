class Movie < ActiveRecord::Base
    def self.all_ratings
  	    result = []
  	    self.select(:rating).uniq.each do |movie|
  		    result.append(movie.rating)
  	end
  	    return result
    end
    
    def self.with_ratings(ratings)
        self.where(rating: ratings)
    end
end
