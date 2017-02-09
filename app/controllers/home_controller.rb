class HomeController < ApplicationController
  def index
    @year = params[:year]
    @min_year = EnergyUsage.minimum(:year)
    @max_year = EnergyUsage.maximum(:year)
    @energy_usages = Building.joins(energy_usages: :measurement)
    @energy_usages = @energy_usages.where(energy_usages: {year: @year}) if @year

    @energy_usages = @energy_usages.page(params[:page]).per(50)
  end
end
