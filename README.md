# NetRunner card recommendation engine

Built on-top of NetRunnerDB user decks, a card recommendation engine.

# How to setup from scratch

What this does is import all the cards&decks from NetRunnerDB into PostgreSQL,
amoritize the data for neo4j batch-import, and finally imports the data to neo4j.

- `git submodule update --init`
- `bundle install`
- 
** You'll need PostgreSQL to continue from here, if you don't you'll need to rewrite
the export to neo4j_csv task, as it relies on PostgreSQL COPY command.

- `cp config/database.yml.sample config/database.yml` Make sure the database.yml is configured
properly to your local PostgreSQL.
- `rake db:create db:migrate`
- `rake import:all` - This task will import all the cards & decks from NetRunnerDB to your DB.
- `rake export:neo4j_csv` - This task will export all the cards & decks for Neo4j batch-import.
- `rake neo4j:install` - Using Neography's task to install neo4j
- `rake neo4j:start` - You can use rake `rake neo4j:start` / `rake neo4j:stop` to toggle on/off the server.
- `brew install maven` - We need Maven to run the import script.
- `./scripts/import_csv.sh` - Using batch-import to import to neo4j the graph.
- `rake neo4j:restart` - We have to restart the neo4j db after the batch import.

## How to update cards.json
- `rake generate:card_score` - Use this task to update the recommendations score in PostgreSQL (Used in export to json)
- `rake export:json` - Use this task to build the cards.json file which stores all the cards metadata (including recommendations)
- `ruby app.rb` - Starts the Sinatra server

At this point if everything ran smoothly, then you can play around with the server
at `http://localhost:4567`
