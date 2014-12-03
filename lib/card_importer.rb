require_relative './nrdb_api.rb'
require_relative '../app/models/card.rb'

class CardImporter
  def self.import
    puts 'Importing cards...'
    cards = NRDBApi.all_cards.map do |card|
      [card.code, card.side, card.type, card.title,
       card.description, card.url, card.imagesrc]
    end

    columns = [:code, :side, :card_type, :title, :description, :nrdb_url, :image_url]
    puts 'Filtering existing cards..'
    cards_to_import = filter_existing_cards(cards)
    cards_to_import = filter_bad_cards(cards_to_import)
    puts "Importing cards: #{cards_to_import}"
    Card.import(columns, cards_to_import)
  end

  private
  def self.filter_existing_cards(cards)
    existing_cards_ids = Card.pluck(:code)
    cards.reject { |c| existing_cards_ids.include? c[0] }
  end

  #Cards that their code starts with '00' are bad, as they're duplicates of newer cards
  #that are actually used in the decks
  def self.filter_bad_cards(cards)
    cards.reject { |c| c[0].start_with? '00' }
  end
end
