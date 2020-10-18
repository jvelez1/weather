# frozen_string_literal: true

require 'httparty'

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

    attr_reader :error, :response

    def initialize(city)
      @city = city.downcase
    end

    def call
      location_id = find_location_id
      return unless location_id

      obtain_city(location_id)
    rescue NotFound => _e
      assign_error("Ups! City not found. Try: #{suggestions.join(', ')}")
      false
    rescue StandardError => e
      assign_error("Ups! There is an error: #{e.message}")
      false
    end

    private

    attr_reader :city

    def find_location_id
      info = parsed_all_cities.find do |data|
        data.dig('name', '__content__').downcase == city
      end
      return info.dig('name', 'id') if info

      raise NotFound
    end

    def suggestions
      city_values = city.split(" ")
      parsed_all_cities.map do |data|
        city_name = data.dig('name', '__content__').downcase
        next unless city_values.map { |a| city_name.include?(a) }.inject(&:|)

        city_name
      end.compact
    end

    def request_all_cities
      self.class.get(BASE_PATH, { query: { **DEFAULT_OPTIONS, division: 102 } })
    end

    def parsed_all_cities
      @parsed_all_cities ||= request_all_cities&.dig('report', 'location', 'data') || []
    end

    def obtain_city(location_id)
      request = request_city(location_id)
      if request.ok?
        @response = request.parsed_response
        true
      else
        assign_error("Ups! There is an error with the weather service")
        false
      end
    end

    def request_city(location_id)
      self.class.get(BASE_PATH, { query: { **DEFAULT_OPTIONS, localidad: location_id } })
    end

    def assign_error(message)
      @error = message
    end
  end
end
