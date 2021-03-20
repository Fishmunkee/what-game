class AdvancedSearchController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @user = current_user
    @genres = Genre.order(:name)
    @platforms = Platform.order(:name)
  end
end
