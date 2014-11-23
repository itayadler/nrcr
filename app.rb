require 'rubygems'
require 'sinatra/activerecord'
require 'haml'
require './lib/recommendations'

class NRCR < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :database_file, 'config/database.yml'

  get '/recommendations/:card_code' do
    @recommendations = Recommendations.by_card_code(params['card_code'])
    @title = @recommendations.shift.title
    haml :recommendations
  end

run! if app_file == $0
end
