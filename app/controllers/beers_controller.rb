class BeersController < ApplicationController
  def index
    query = params[:query]
    @recent_searches = recent_searches
    return render "start" unless query

    save_search

    @beers = FetchBeers.call(query:, page:)
    @pagination = paginate(@beers)
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
    params[:page]&.to_i || 1
  end

  def paginate(beers)
    pagination = {page:}
    pagination[:next_page] = beers_path(query: params[:query], page: page + 1) if beers.size == 10
    pagination[:prev_page] = beers_path(query: params[:query], page: page - 1) if page > 1
    pagination
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
