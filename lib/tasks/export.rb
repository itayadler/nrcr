require 'benchmark'
require './app'
require_relative '../recommendations'

namespace :export do

  desc 'Export all recommendations to JSON'
  task :json do
    cards = Card.all.map do |card|
      recommendations = Recommendations.by_card_code(card.code)
      {
        id: card.code,
        title: card.title,
        img_url: "http://netrunnerdb.com#{card.image_url}",
        card_type: card.card_type,
        recommendations: recommendations.map(&:code)
      }
    end
    File.open("#{Dir.pwd}/public/javascripts/cards.json", 'w') do |file|
      file.write(cards.to_json)
    end
  end

  CARD_NODES = 'card_nodes'
  DECK_NODES = 'deck_nodes'
  CARD_DECK_RELATIONSHIPS = 'card_deck_relationships'

  DROP_TEMP_TABLES = <<-SQL
    DROP TABLE IF EXISTS #{CARD_NODES};
    DROP TABLE IF EXISTS #{DECK_NODES};
    DROP TABLE IF EXISTS #{CARD_DECK_RELATIONSHIPS};
  SQL
  CREATE_CARD_NODES_TABLE = <<-SQL
    SELECT row_number() OVER (ORDER BY code) as node_id,
    code, side, card_type, title, image_url
    INTO #{CARD_NODES}
    FROM cards
  SQL
  #kind_id 1 is the a feature of type movie.
  CREATE_DECK_NODES_TABLE = <<-SQL
    SELECT (SELECT count(*) from #{CARD_NODES})+row_number() OVER (ORDER BY nrdb_id) as node_id,
    nrdb_id, name
    INTO #{DECK_NODES} 
    FROM decks
  SQL
  CREATE_CARD_DECK_RELATIONSHIPS_TABLE = <<-SQL
    SELECT #{CARD_NODES}.node_id AS start, #{DECK_NODES}.node_id AS end, 'card_in_deck' AS type
    INTO #{CARD_DECK_RELATIONSHIPS}
    FROM deck_cards 
    INNER JOIN #{CARD_NODES} ON #{CARD_NODES}.code = deck_cards.card_code
    INNER JOIN #{DECK_NODES} ON #{DECK_NODES}.nrdb_id = deck_cards.deck_id
  SQL

  desc "exports movie/person tables to nodes and relationships"
  task :neo4j_csv do
    #Setting up the nodes and relationships tables. Doing pretty much the same thing described 
    #in this blog post, just for the IMDBPy schema: http://maxdemarzi.com/2012/02/28/batch-importer-part-2/
    execute_script_with_log('DROP TEMP TABLES', DROP_TEMP_TABLES)
    execute_script_with_log('CREATE CARD NODES TABLE', CREATE_CARD_NODES_TABLE)
    execute_script_with_log('CREATE DECK NODES TABLE', CREATE_DECK_NODES_TABLE)
    execute_script_with_log('CREATE DECK_CARDS NODES TABLE', CREATE_CARD_DECK_RELATIONSHIPS_TABLE)

    save_path = "#{Dir.pwd}/export_graph_csv"
    Dir.mkdir(save_path) unless Dir.exist?(save_path)

    export_to_csv(['node_id', 'code', 'side', 'card_type', 'title', 'image_url'], CARD_NODES, save_path)
    export_to_csv(['node_id','nrdb_id','name'], DECK_NODES, save_path)
    export_to_csv(['start',"#{CARD_DECK_RELATIONSHIPS}.end", 'type'], CARD_DECK_RELATIONSHIPS, save_path)
  end

  def execute_script_with_log(name, script)
    puts "Executing #{name}..."
    benchmark = Benchmark.realtime do
      ActiveRecord::Base.connection.execute(script)
    end
    puts "Finished executing #{name} in #{benchmark} seconds"
  end

  def export_to_csv(columns, table_name, save_path)
    save_path = "#{save_path}/#{table_name}.csv"
    script = <<-SQL
      COPY (SELECT #{columns.join(', ')} FROM #{table_name}) TO '#{save_path}' CSV HEADER DELIMITER E'\t'
    SQL
    execute_script_with_log("COPY #{table_name} TO #{save_path}", script)
  end
end

