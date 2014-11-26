require 'active_support/all'
require_relative './nrdb_api.rb'
require_relative '../app/models/deck.rb'
require_relative '../app/models/deck_card.rb'

class DeckImporter
  DECK_CARDS_COLUMNS = [:card_code, :deck_id]
  NETRUNNER_DB_DATE_OF_ORIGIN = '2013-09-26'

  def self.import(start_date=DateTime.parse(NETRUNNER_DB_DATE_OF_ORIGIN))
    existing_deck = Deck.order('creation_date DESC').first
    if existing_deck.present?
      start_date = existing_deck.creation_date.yesterday.to_date
    end
    (start_date..DateTime.now).each do |date|
      puts "Importing decks from #{date}.."
      NRDBApi.decklists_by_date(date).each do |deck|
        if Deck.where(nrdb_id: deck.id).blank?
          puts "Importing deck #{deck.id}"
          import_deck(deck)
          import_deck_cards(deck.id, deck.cards.keys)
        end
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

