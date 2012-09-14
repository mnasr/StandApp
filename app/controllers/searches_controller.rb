class SearchesController < ApplicationController
  def create
    @title = "Search results"
    @keywords = params[:search]
    @results = Array.new
    if @keywords.present?
      search_keywords = "%#{@keywords}%"
      @results << User.where("email LIKE ? OR fullname LIKE ?", search_keywords, search_keywords).all
      @results << Entry.where("category LIKE ? OR description LIKE ?", search_keywords, search_keywords).all
      @results = @results.compact.flatten
    end

    render :action => :show, :locals => {:results => @results, :keywords => @keywords}
  end

  def show
  @title = "Search results"
  end
end