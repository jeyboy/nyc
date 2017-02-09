class EnergyUsagePresenter
  class_attribute :year
  class_attribute :energy_usages
  class_attribute :min_year
  class_attribute :max_year
  class_attribute :measurements

  def initialize(params)
    @min_year = EnergyUsage.minimum(:year)
    @max_year = EnergyUsage.maximum(:year)
    @year = params[:year] || @min_year

    @energy_usages = Building.joins(energy_usages: :measurement).where(energy_usages: {year: @year})
                         .order('buildings.name','measurements.name')
                         .group('buildings.name','measurements.name')
                         .sum(:amount)
    @energy_usages = @energy_usages.each_with_object({}) do |item, hash|
      hash[item.first.first]||={}
      hash[item.first.first][item.first.last]=item.last
    end

    @measurements = Measurement.pluck(:name)
  end
end