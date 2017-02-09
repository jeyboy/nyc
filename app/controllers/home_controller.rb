class HomeController < ApplicationController
  def index
    @year = params[:year]
    @min_year = EnergyUsage.minimum(:year)
    @max_year = EnergyUsage.maximum(:year)
    @energy_usage = Building.joins(energy_usages: :measurement)
    @energy_usage = @energy_usage.where(energy_usages: {year: @year}) if @year

    @energy_usage = @energy_usage.per(50).page params[:page]
  end
end
