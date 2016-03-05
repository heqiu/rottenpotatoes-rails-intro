class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.new.rating_values
    @selected_rating = Hash.new
    
    if params[:ratings]
      params[:ratings].each_key do |rating|
        if params[:ratings] != nil
          @selected_rating[rating] = true 
        else
          @selected_rating[rating] = false
        end
      end
    end
    
    if params[:sort_by]
      puts case params[:sort_by]
        when "title"
          @movies = Movie.order(params[:sort_by])
          @title_header = 'hilite'
        when "release_date"
          @movies = Movie.order(params[:sort_by])
          @release_date_header = 'hilite'
      end
    else
      if @selected_rating.values.all?{|rating| rating==false}
        @movies = Movie.all 
      else
        @movies = Movie.where(rating: params[:ratings].keys )
      end
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
