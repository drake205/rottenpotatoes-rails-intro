class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    #@movies = Movie.all
    #@movies = Movie.order(params[:sort])
    if params[:sort] != nil
      @sort_by = params[:sort]
      if params[:sort] != session[:sort]
        session[:sort] = params[:sort]
        redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
      end
    elsif session[:sort] != nil
      @sort_by = session[:sort]
    end
    
    if params[:ratings] != nil
      @ratings = params[:ratings]
      if params[:ratings] != session[:ratings]
        session[:ratings] = params[:ratings]
        redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
      end
      checked_ratings = @ratings.keys
    elsif session[:ratings] != nil
      @ratings = session[:ratings]
      checked_ratings = @ratings.keys
    end
    
    #@ratings = params[:ratings]
    #if @ratings != nil
    #  checked_ratings = @ratings.keys
    #  @movies = Movie.with_ratings(checked_ratings)
    #else
    #  @ratings = Movie.all_ratings
    #end
    @movies = Movie.with_ratings(checked_ratings).order(@sort_by)
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
