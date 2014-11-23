require 'hashie'
require_relative '../app/models/card_node'
require_relative '../config/neo4j'

class Recommendations

  def self.by_card_code(card_code, num_of_results=40)
    card_node = CardNode.where(code: card_code).first
    script = <<-GREMLIN
      g.v(#{card_node.node_id}).as('x').out.in
      .groupCount.cap().next()
      .sort{-it.value}[0..#{num_of_results}].collect{ r = it.key.map.next(); r.put('rank', it.value); r }
    GREMLIN
    $neo.execute_script(script).map do |node|
      Hashie::Mash.new(node)
    end
  end

end
