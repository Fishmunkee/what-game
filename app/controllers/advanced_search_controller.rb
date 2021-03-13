class AdvancedSearchController < ApplicationController
  def index
    @genres = Genre.order(:name)
    @platforms = Platform.order(:name)
  end
end
