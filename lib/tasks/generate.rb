require './app'
require './app/models/deck'
require './app/models/deck_card'
require './app/models/card_score'
require_relative '../recommendations'

namespace :generate do

  task :card_score do
    cards = CardNode.all
    card_mapping = Hash[cards.map{|c| [c.node_id.to_s, c.code]}]
    cards_rank = DeckCard.select(:card_code).group(:card_code).count
    deck_count = Deck.count.to_f
    card_score_columns = [:source_card_code, :dest_card_code, :score]
    CardScore.delete_all
    cards.each do |c1|
      puts "Importing card #{c1.code}"
      associated_cards = Recommendations.associated_cards(c1.node_id)
      scores = []
      c1_node_id = c1.node_id.to_s
      associated_cards.each do |c2_node_id, count|
        next if c1_node_id == c2_node_id
        c2_code = card_mapping[c2_node_id]
        dxy = count.to_f
        dx = cards_rank[c2_code].to_f
        dy = cards_rank[c1.code].to_f
        ptagscore = dxy / dy
        pscore = dx / deck_count
        score = ptagscore / pscore
        scores << [c1.code, c2_code, score]
      end
      CardScore.import(card_score_columns, scores, validate: false)
    end
  end
end
