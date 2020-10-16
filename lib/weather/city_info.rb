require 'weather/request'
require 'weather/city_dto'
require 'ostruct'

module Weather
  class CityInfo
    def initialize(city)
      @request = Weather::Request.new(city)
    end

    def call
      if request.call && request.body.ok?
        result(valid?: true, data: CityDTO.call(request.body))
      else
        result(valid: false, error: request.error)
      end
    end

    private

    attr_reader :request

    def result(**args)
      OpenStruct.new(args)
    end
  end
end
