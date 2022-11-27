class BeersController < ApplicationController
  def index
    query = params[:query]
    return render "start" unless query

    @beers = FetchBeers.call(query:, page:)
    render "empty_search_result" if @beers.blank?
  end

  def show
    @beer = FetchBeer.call(external_id: params[:id])
  rescue PunkApi::Client::NotFoundError => error
    Rails.logger.error(error.message)
    render "not_found"
  end

  private

  def page
    params[:page] || 1
  end
end
