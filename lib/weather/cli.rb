# frozen_string_literal: true

require 'thor'
require 'weather/city_info'

module Weather
  class CLI < Thor
    map '-today' => :today
    map '-av_max' => :av_max
    map '-av_min' => :av_min

    desc '-today city', 'will display the min and max temperature for today'
    def today(city)
      display_info(city) do |city_info|
        puts "
          For Today: #{city_info.data[:label]}
          Minimum: #{city_info.data.dig(:minimum, :today)}°
          Maximum: #{city_info.data.dig(:maximum, :today)}°
        "
      end
    end

    desc '-av_max city', 'will display the average max temperature for this week'
    def av_max(city)
      display_info(city) do |city_info|
        puts "
          Maximum Average for this week: #{city_info.data.dig(:maximum, :today)}°
        "
      end
    end

    desc '-av_min city', 'will display the average min temperature for this week'
    def av_min(city)
      display_info(city) do |city_info|
        puts "
          Minimum Average for this week: #{city_info.data.dig(:minimum, :today)}°
        "
      end
    end

    private

    def display_info(city)
      city_info = obtain_info(city)
      if city_info.valid?
        yield(city_info)
      else
        puts city_info.error
      end
    end

    def obtain_info(city)
      CityInfo.new(city).call
    end
  end
end
