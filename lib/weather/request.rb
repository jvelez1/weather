# frozen_string_literal: true

require 'httparty'
require "byebug"


module Weather
  class Request
    class NotFound < StandardError; end

    include HTTParty

    BASE_PATH = '/index.php'

    DEFAULT_OPTIONS = {
      affiliate_id: 'zdo2c683olan',
      api_lang: 'es'
    }.freeze

    base_uri 'http://api.tiempo.com'

    attr_reader :error, :body

    def initialize(city)
      @city = city.downcase
    end

    def call
      location_id = find_location
      return unless location_id

      @body = obtain_city(location_id)
    rescue NotFound => _e
      @error = "Ups! City not found. Try: #{suggestions.join(', ')}"
      false
    rescue StandardError => e
      @error = "Ups! There is and error: #{e}"
      false
    end

    private

    attr_reader :city

    def find_location
      cites = parsed_all_cities
      info = cites.find do |data|
        data.dig('name', '__content__').downcase == city
      end
      return info&.dig('name', 'id') if info

      raise NotFound
    end

    def suggestions
      parsed_all_cities.map do |data|
        city_name = data.dig('name', '__content__')
        next unless city_name.downcase.include?(city)

        city_name
      end.compact
    end

    def all_cities
      self.class.get(BASE_PATH, { query: { **DEFAULT_OPTIONS, division: 102 } })
    end

    def parsed_all_cities
      @parsed_all_cities ||= all_cities&.dig('report', 'location', 'data') || []
    end

    def obtain_city(location_id)
      self.class.get(BASE_PATH, { query: { **DEFAULT_OPTIONS, localidad: location_id } })
    end
  end
end
