require 'sinatra'
require 'erb'
require 'sass'
require './student'

configure do
  enable :sessions
  set :username, '11'
  set :password, '11'
end

#set up database
configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/student.db")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end

#attach css style
get('/styles.css'){ scss :styles }

get '/' do
  erb :home
end

get '/about' do
  @title = "All About This Website"
  erb :about
end

# go to login page
get '/login' do
  erb :login
end

#login if info is correct otherwise go back to login page
post '/login' do
  if params[:username] == settings.username && params[:password] == settings.password
    session[:admin] = true
    redirect to('/student')
  else
    erb :login
  end
end

#logout
get '/logout' do 
  session.clear
  redirect to('/login')
end

get '/contact' do
  erb :contact
end

not_found do
  erb :not_found
end
