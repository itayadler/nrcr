# Netrunner card recommendation engine

Build on-top of NetrunnerDB user decks, a card recommendation engine.

# Howto setup from scratch

What this does is import all the cards&decks from NetrunnerDB into PostgreSQL,
amoritize the data for neo4j batch-import, and finally imports the data to neo4j.

- `git submodule update --init` TODO: Make sure this actually works from scratch
- `bundle install`
** You'll need PostgreSQL to continue from here, if you don't you'll need to rewrite
the export to neo4j_csv task, as it relies on PostgreSQL COPY command.
- `cp config/database.yml.sample config/database.yml` Make sure the database.yml is configured
properly to your local PostgreSQL.
- `rake db:create db:migrate`
- `rake import:all` - This task will import all the cards & decks from NetrunnerDB to your DB.
- `rake export:neo4j_csv` - This task will export all the cards & decks for Neo4j batch-import.
- `rake neo4j:install` - Using Neography's task to install neo4j
- `rake neo4j:start` - You can use rake `neo4j:start` / `rake neo4j:stop` to toggle on/off the server.
- `brew install maven` - We need Maven to run the import script.
- `./scripts/import_csv.sh` - Using batch-import to import to neo4j the graph.
- `ruby app.rb` - Starts the Sinatra server

At this point if everything ran smoothly, then you can play around with the server
at `http://localhost:4567`
