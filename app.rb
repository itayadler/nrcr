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

  get '/' do
    haml :app
  end

run! if app_file == $0
end
