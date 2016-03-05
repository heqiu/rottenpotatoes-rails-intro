class Movie < ActiveRecord::Base
    def rating_values
        ['G','PG','PG-13','R']
    end
end
