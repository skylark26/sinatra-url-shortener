#!/usr/bin/env ruby

require 'sinatra'
require 'mongoid'
require 'haml'

set :haml, {:format => :html5, :attr_wrapper => '"'}

configure do
  Mongoid.load!("./mongoid.yml")
end

class Url
  include Mongoid::Document
  field :code, type: String
  field :url, type: String
end

get '/' do
  haml :create
end

post '/create' do
  @code = (('a'..'z').to_a+('A'..'Z').to_a+(0..9).to_a).shuffle[0,8].join
  @url = params[:url]
  url = Url.new
  url.url = @url
  url.code = @code
  url.save
  
  redirect "/show-url/#{@code}"
end

get '/show-url/:code' do
  @showcode = params[:code]
  @host = request.env["HTTP_HOST"]
  erb "<a href=\"http://#{@host}/#{@showcode}\">http://#{@host}/#{@showcode}</a>"
end

get '/:code' do
  @url = Url.find_by(code: params[:code])
  redirect @url.url
end