class EnergyUsagePresenter
  class_attribute :year
  class_attribute :energy_usages
  class_attribute :min_year
  class_attribute :max_year
  class_attribute :measurements
  class_attribute :id_relations

  def initialize(params)
    @min_year = EnergyUsage.minimum(:year)
    @max_year = EnergyUsage.maximum(:year)
    @year = params[:year] || @min_year

    @energy_usages = Building.joins(:energy_usages).where(energy_usages: {year: @year})
    @energy_usages = @energy_usages.order('buildings.name','energy_usages.measurement_id')
       .group('buildings.name','energy_usages.measurement_id')
       .sum(:amount)

    @id_relations = {}
    @measurements = Measurement.all.each_with_object({}) do |measure, res|
      res[measure.id] = measure.name
      @id_relations[measure.id] = @id_relations.size
    end
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
      attrs = v.each_with_object([0.0] * @measurements.size) do |val, res|
        res[@id_relations[val[0][1]]] = ActionController::Base.helpers.number_to_currency(val[1])
      end

      yield k[0], @year, attrs
    end
  end
end