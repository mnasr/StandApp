class SearchesController < ApplicationController
  def show
    
  end

  def new
    
  end
  
  def create
    keywords = params[:search]
    @results = Array.new
    @results << User.where("email LIKE ? OR fullname LIKE ?", keywords, keywords).all
    @results << Entry.where("category LIKE ? OR description LIKE ?", keywords, keywords).all
    @results = @results.compact.flatten

    render :action => :show, :locals => {:results => @results}
  end
end
