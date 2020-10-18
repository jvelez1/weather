# frozen_string_literal: true

module Weather
  class CityDTO
    MINIMUM = 0
    MAXIMUM = 1
    DAYS = 4
    def self.call(info)
      new(info).transform
    end

    def initialize(info)
      @info = info.dig('report', 'location', 'var')
    end

    def transform
      {
        label: obtain_data(DAYS)[0]['value'],
        minimum: minimum_data,
        maximum: maximum_data
      }
    end

    private

    attr_reader :info

    def minimum_data
      build_data_hash do
        obtain_data(MINIMUM)
      end
    end

    def maximum_data
      build_data_hash do
        obtain_data(MAXIMUM)
      end
    end

    def obtain_data(index)
      info[index].dig('data', 'forecast')
    end

    def build_data_hash
      data = yield
      {
        today: data[0]['value'],
        week_average: data.sum { |day| day['value'].to_i } / 7
      }
    end
  end
end
