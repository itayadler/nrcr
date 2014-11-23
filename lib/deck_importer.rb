require 'active_support/all'
require_relative './nrdb_api.rb'
require_relative '../app/models/deck.rb'
require_relative '../app/models/deck_card.rb'

class DeckImporter
  DECK_CARDS_COLUMNS = [:card_code, :deck_id]
  def self.import(start_date=DateTime.parse('2013-09-26'))
    (start_date..DateTime.now).map do |date|
      NRDBApi.decklists_by_date(date).map do |deck|
        import_deck(deck)
        import_deck_cards(deck.id, deck.cards.keys)
      end
    end
  end


  private
  def self.import_deck(deck)
    Deck.create({
      nrdb_id: deck.id,
      name: deck.name,
      creation_date: deck.creation,
      description: deck.description,
      username: deck.username
    })
  end

  def self.import_deck_cards(deck_id, deck_cards)
    values = deck_cards.map do |card_code|
      [card_code, deck_id]
    end
    DeckCard.import(DECK_CARDS_COLUMNS, values)
  end
end

