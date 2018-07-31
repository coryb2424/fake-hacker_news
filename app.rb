require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

require_relative "config/application"

set :views, (proc { File.join(root, "app/views") })
set :public_folder, 'public'
set :bind, '0.0.0.0'

HOLD = []


get '/' do
  @posts = Post.order(votes: :desc)
  erb :posts # Do not remove this line
end

get '/new' do
  erb :new
end

post '/new' do
  if HOLD.empty?
    user = User.find_by(username: params[:username])
  else
    user = User.find_by(username: HOLD[:username])
  end

  if user.nil?
    HOLD = params
    redirect '/new_user'
  end
  if HOLD.empty?
    post = Post.new(name: params[:name], url: params[:url])
    user.posts << post
    post.save!
  else
    post = Post.new(name: HOLD[:name], url: HOLD[:url])
    user.posts << post
    post.save!
  end
  user.posts << post
  HOLD = []
  redirect '/'
end

get '/new_user' do
  erb :new_user
end

post '/new_user' do
  User.create!(params)
  redirect '/new', 307
end

get '/upvote/:id' do
  post = Post.find(params[:id])
  post.votes += 1
  post.save
  redirect '/'
end

# TODO: add more routes to your app!
