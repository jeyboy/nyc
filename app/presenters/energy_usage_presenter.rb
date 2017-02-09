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

    @energy_usages = Building.joins(:energy_usages)
    @energy_usages = @energy_usages.where(energy_usages: {year: @year}) if @year

    @energy_usages = @energy_usages.order('buildings.name','energy_usages.measurement_id')
       .group('buildings.name','energy_usages.measurement_id')
       .sum(:amount)

    @measurements = Measurement.all.each_with_object({}) { |measure, res| res[measure.id] = measure.name }

    @energy_usages = @energy_usages.group_by {|val| [val[0][0], val[0][2]]}
  end

  def each_measurement
    raise LocalJumpError unless block_given?

    @measurements.each_pair do |_, name|
      yield name
    end
  end

  def each_building_attrs
    raise LocalJumpError unless block_given?
    @energy_usages.each_pair do |k, v|
      i = 0
      attrs = @measurements.each_with_object([]) do |(mid, _), res|
        res << ((v[i][0][1] rescue -1) == mid ? v[i][1] : 0)
        i += 1
      end

      yield k[0], attrs
    end
  end
end