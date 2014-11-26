require 'rubygems'
require 'sinatra/activerecord'
require 'sinatra/json'
require 'haml'
require './lib/recommendations'
require './app/models/card'

class NRCR < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :database_file, 'config/database.yml'

  get '/recommendations/:card_code' do
    @recommendations = Recommendations.by_card_code(params['card_code'])
    @title = Card.where(code: params['card_code']).first.title
    haml :recommendations
  end

  get '/api/recommendations/:card_code' do
    code = params['card_code']
    recommendations = Recommendations.by_card_code(code).map do |rec|
      {
        title: rec.title,
        image_url: "http://netrunnerdb.com/#{rec.image_url}",
        type: rec.card_type
      }
    end
    json recommendations
  end

  get '/' do
    @cards = Card.pluck(:code, :title)
    haml :app
  end

run! if app_file == $0
end
