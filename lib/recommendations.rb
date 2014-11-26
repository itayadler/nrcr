require 'hashie'
require_relative '../app/models/card_node'
require_relative '../app/models/deck_card'
require_relative '../config/neo4j'

TOP_CARDS_LIMIT = 0

class Recommendations

  def self.by_card_code(card_code, num_of_results=40)
    card_node = CardNode.where(code: card_code).first
    script = <<-GREMLIN
      y = [#{outliers.join(',')}]
      card = g.v(#{card_node.node_id})
      card.as('x').out.in.except(y).except([card])
      .groupCount.cap().next()
      .sort{-it.value}[0..#{num_of_results}].collect{ r = it.key.map.next(); r.put('rank', it.value); r }
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
