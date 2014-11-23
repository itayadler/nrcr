require_relative './nrdb_api.rb'
require_relative '../app/models/card.rb'

class CardImporter
  def self.import
    cards = NRDBApi.all_cards.map do |card|
      [card.code, card.side, card.type, card.title,
       card.description, card.url, card.imagesrc]
    end

    columns = [:code, :side, :card_type, :title, :description, :nrdb_url, :image_url]
    cards_to_import = filter_existing_cards(cards)
    Card.import(columns, cards_to_import)
  end

  private
  def self.filter_existing_cards(cards)
    existing_cards_ids = Card.pluck(:code)
    cards.reject { |c| existing_cards_ids.include? c[0] }
  end
end
