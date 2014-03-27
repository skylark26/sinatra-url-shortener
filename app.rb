#!/usr/bin/env ruby

require 'sinatra'
require 'mongoid'

configure do
  Mongoid.load!("./mongoid.yml")
end

class Url
  include Mongoid::Document
  field :code, type: String
  field :url, type: String
end

get '/' do
  
end

post '/create' do
  @code = (('a'..'z').to_a+('A'..'Z').to_a+(0..9).to_a).shuffle[0,8].join
  @url = params[:url]
  url = Url.new
  url.url = @url
  url.save
  
  redirect "/show-code?code=#{@code}"
end

get '/:code' do
  @url = Url.find_by(code: params[:code])
  redirect @url.url
end

get '/show-code?code=:code' do
  @code = params[:code]
  
end
