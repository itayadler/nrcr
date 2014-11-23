# Netrunner card recommendation engine

Build on-top of NetrunnerDB user decks, a card recommender.

# TODO

- [x] Setup an app with Sinatra & ActiveRecord
- [x] Import decks from NetrunnerDB
- [x] Import decks from NetrunnerDB
- [x] Write an API wrapper for NetrunnerDB
  - [x] Get cards
  - [x] Get decklist
- [x] Build a rake task that exports Card/Decks and their relations to
a CSV for neo4j batch-import
- [x] Write a gremlin query that for a given card_code gives the recommended cards.
- [ ] Add more features for recommendation query
  - [ ] Filter by card type
