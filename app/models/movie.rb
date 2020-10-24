class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 R)
  end
  
#   def self.with_ratings(ratings_list)
#     if ratings_list == nil
#       Movies.all
#     else
#       Movies.where()
#     end
#   end
      
end
