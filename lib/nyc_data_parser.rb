require 'rest-client'

class NycDataParser
  response = RestClient::Request.execute(
    method: :get,
    url: 'https://data.cityofnewyork.us/resource/dnpn-ts5d.json'
  )
  json = JSON::parse(response.body)

  measurements = Measurement.all.each_with_object({}) {|measure, res| res[measure.name] = measure.id }

  ActiveRecord::Base.transaction do
    json.each do |row|
      measurement_id = measurements[row['measurement']]
      location, building = row['location_1_location'].split(/ \[|\]/)


    end
  end
end