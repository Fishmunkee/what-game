class AdvancedSearchController < ApplicationController
  def index
    @user = current_user
    @genres = Genre.order(:name)
    @platforms = Platform.order(:name)
  end
end
