require './app'
require_relative '../card_importer.rb'
require_relative '../deck_importer.rb'

namespace :import do

  desc 'Imports cards&decks from NetrunnerDB'
  task :all => [:cards, :decks] do
  end

  desc 'Import cards from NetrunnerDB'
  task :cards do
    CardImporter.import
  end

  desc 'Import decks from NetrunnerDB'
  task :decks do
    DeckImporter.import
  end
end
