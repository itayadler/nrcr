require 'httparty'
require 'hashie'

class NRDBApi
  HOST = 'http://netrunnerdb.com'
  API_PATH = '/api'

  def self.decklists_by_date(date)
    url = api_url("/decklists/by_date/#{date.strftime('%F')}")
    HTTParty.get(url).parsed_response.map do |deck|
      Hashie::Mash.new(deck)
    end
  end

  def self.decklist(id)
    url = api_url("/decklist/#{id}")
    deck = HTTParty.get(url).parsed_response
    Hashie::Mash.new(deck)
  end

  def self.all_cards
    url = api_url('/cards')
    HTTParty.get(url).parsed_response.map do |card|
      Hashie::Mash.new(card)
    end
  end

  private
  def self.api_url(action_path)
    "#{HOST}#{API_PATH}#{action_path}"
  end
end
