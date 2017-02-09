class HomeController < ApplicationController
  def index
    @presenter = EnergyUsagePresenter.new(params)
  end
end
