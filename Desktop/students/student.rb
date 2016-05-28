require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/student.db")
class Student
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :age, Integer

end

configure do
  enable :sessions
  set :username, '11'
  set :password, '11'
end

DataMapper.finalize

get '/student' do
  @student = Student.all
  erb :student
end

get '/student/new' do
  halt(401, 'Not Autorized') unless session[:admin]
  @student = Student.new
  erb :new_student
end

get '/student/:id' do
  @student = Student.get(params[:id])
  erb :show_student
end

get '/student/:id/edit' do
  @student = Student.get(params[:id])
  erb :edit_student
end

post '/student' do  
  student = Student.create(params[:student])
  student.name = params[:name]
  student.age = params[:age]
  student.save
  redirect to("/student/#{student.id}")
end

put '/student/:id' do
  student = Student.get(params[:id])
  student.update(:name=>params[:name], :age=>params[:age])
  redirect to("/student/#{student.id}")
end

delete '/student/:id' do
  Student.get(params[:id]).destroy
  redirect to('/student')
end

Student.auto_upgrade!
