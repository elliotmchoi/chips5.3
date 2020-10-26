class MoviesController < ApplicationController
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    
    if params[:ratings] == nil and params[:sort] == nil and session[:ratings] == nil and params[:sort] == nil
      d_movies = Movie.all
      @ratings_to_show = []
      @sort = nil
    else
      # undo sort.
      if params[:ratings] == nil and ((params[:sort] == nil and session[:sort] != nil) or (params[:sort] == session[:sort]))
        @ratings_to_show = []
        @sort = nil
        d_movies = Movie.all
      # click only sort.
      elsif params[:ratings] == nil and params[:sort] != nil and session[:ratings].empty?
        @ratings_to_show = []
        @sort = params[:sort]
        d_movies = Movie.all
      # click refresh then sort.
      elsif params[:ratings] != nil and params[:sort] != nil
        @ratings_to_show = params[:ratings].keys
        @sort = params[:sort]
        d_movies = Movie.where("rating IN (?)", @ratings_to_show)
      # click different sort.
      elsif params[:ratings] == nil and session[:ratings] != nil and params[:sort] != nil
        @ratings_to_show = session[:ratings]
        @sort = params[:sort]
        d_movies = Movie.where("rating IN (?)", @ratings_to_show)
      # click refresh after sort
      elsif params[:ratings] != nil and params[:sort] == nil and session[:sort] != nil
        @ratings_to_show = params[:ratings].keys
        @sort = session[:sort]
        d_movies = Movie.where("rating IN (?)", @ratings_to_show)
      # filter then sort
      elsif params[:ratings] == nil and params[:sort] != nil and session[:ratings] != nil
        @ratings_to_show = session[:ratings]
        @sort = params[:sort]
        d_movies = Movie.where("rating IN (?)", @ratings_to_show)
      # click only filter
      else
        @ratings_to_show = params[:ratings].keys
        @sort = nil
        d_movies = Movie.where("rating IN (?)", @ratings_to_show)
      end
    end
    
    if @sort == 'Title' or @sort == 'Date'
      if @sort == 'Title'
        d_movies = d_movies.order("title ASC")
      else
        d_movies = d_movies.order("release_date ASC")
      end
    end

    @movies = d_movies
    session[:sort] = @sort
    session[:ratings] = @ratings_to_show
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
