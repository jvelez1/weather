# frozen_string_literal: true

require 'thor'
require 'weather/city'

module Weather
  class CLI < Thor
    map '-today' => :today
    map '-av_max' => :av_max
    map '-av_min' => :av_min

    desc '-today city', 'will display the min and max temperature for today'
    def today(city)
      display_info(city) do |city_data|
        p "For Today #{city_data[:label]}: Minimum: #{city_data.dig(:minimum, :today)}° | Maximum: #{city_data.dig(:maximum, :today)}°"
      end
    end

    desc '-av_max city', 'will display the average max temperature for this week'
    def av_max(city)
      display_info(city) do |city_data|
        p "Maximum Average for this week: #{city_data.dig(:maximum, :week_average)}°"
      end
    end

    desc '-av_min city', 'will display the average min temperature for this week'
    def av_min(city)
      display_info(city) do |city_data|
        p "Minimum Average for this week: #{city_data.dig(:minimum, :week_average)}°"
      end
    end

    private

    def display_info(city)
      city_info = City.new(city).call
      if city_info.valid?
        yield(city_info.data)
      else
        puts city_info.error
      end
    end

    def self.exit_on_failure?
      true
    end
  end
end
