class MoviesController < ApplicationController

  def get_ratings
    ratings= Array.new
    @movies=Movie.find(:all)
    @movies.each do |m|
      ratings<< m.rating unless ratings.include?(m.rating)
    end
    return ratings
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    debugger
    @all_ratings=get_ratings
    @checked_ratings=params[:ratings].keys if params.has_key?(:ratings) 
    if params[:order] == "1"
       params.has_key?(:filter) ? @movies = Movie.where(:rating => params[:filter]).order("title") :  @movies = Movie.find(:all, :order => "title")
       @hilite_title="Y"
    elsif params[:order] == "2"       
       params.has_key?(:filter) ? @movies = Movie.where(:rating => params[:filter]).order("release_date") : @movies = Movie.find(:all, :order => "release_date")
       @hilite_release_date="Y"
    else
       #params.has_key?(:ratings) ? @movies = Movie.find_all_by_rating(@checked_ratings) : @movies = Movie.find(:all)
       params.has_key?(:ratings) ? @movies = Movie.where(:rating => @checked_ratings) : @movies = Movie.find(:all)
    end
  end
  

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
