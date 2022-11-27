class BeersController < ApplicationController
  def index
    query = params[:query]
    @recent_searches = recent_searches
    return render "start" unless query

    save_search

    @beers = FetchBeers.call(query:, page:)
    render "empty_search_result" if @beers.blank?
  end

  def show
    @beer = FetchBeer.call(external_id: params[:id])
    @recent_searches = recent_searches
  rescue PunkApi::Client::NotFoundError => error
    Rails.logger.error(error.message)
    render "not_found"
  end

  private

  def page
    params[:page] || 1
  end

  def save_search
    query = params[:query]
    return if query.blank?

    searches = recent_searches
    searches.unshift query unless searches.include? query
    session[:recent_searches] = searches[..4]
  end

  def recent_searches
    session[:recent_searches]&.dup || []
  end
end
