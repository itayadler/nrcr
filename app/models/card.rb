require 'activerecord-import/base'

class Card < ActiveRecord::Base

  #It appears cards with that starts with the 00 code are
  #duplicates of cards that start with 01, and they end up
  #not being used by the decks.
  default_scope { where('code NOT LIKE ?', '00%') }
end
