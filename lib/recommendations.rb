require 'hashie'
require_relative '../app/models/card_node'
require_relative '../app/models/card_score'
require_relative '../app/models/deck_card'
require_relative '../config/neo4j'

TOP_CARDS_LIMIT = 0

class Recommendations

  def self.shared_decks_count(card_source_id, dest_card_id)
    $neo.execute_script("g.V.retain([g.v(#{card_source_id}), g.v(#{dest_card_id})]).out.groupCount.cap.next().grep{it.value > 1}").count
  end

  def self.associated_cards(card_node_id)
    $neo.execute_script("g.V[#{card_node_id}].out.in.node_id").inject(Hash.new(0)) { |memo,e| memo[e] += 1; memo }
  end

  def self.new_by_card_code(card_code, num_of_results=24)
    ids = CardScore.where(source_card_code: card_code).order('score DESC').pluck(:dest_card_code).first(num_of_results)
    CardNode.where(code: ids)
  end

  def self.by_card_code(card_code, num_of_results=24)
    card_node = CardNode.where(code: card_code).first
    script = <<-GREMLIN
      y = [#{outliers.join(',')}]
      card = g.v(#{card_node.node_id})
      card.as('x').out.in.except(y).except([card])
      .groupCount.cap().next()
      .sort{-it.value}[0..#{num_of_results-1}].collect{ r = it.key.map.next(); r.put('rank', it.value); r }
    GREMLIN
    $neo.execute_script(script).map do |node|
      Hashie::Mash.new(node)
    end
  end

  def self.outliers
    ids = DeckCard.group(:card_code).count.sort { |a,b| b[1] <=> a[1]  }.first(TOP_CARDS_LIMIT).map { |a| a[0] }
    CardNode.where(code: ids).map(&:node_id).map { |a| "g.v(#{a})" }
  end

end
