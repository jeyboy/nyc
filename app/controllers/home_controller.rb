class HomeController < ApplicationController
  def index
    @presenter = EnergyUsagePresenter.new(params)
    respond_to :html, :js
  end
end
