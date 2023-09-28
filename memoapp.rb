# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/json'
require 'cgi'

FILE_PATH = 'public/memoapp.json'

def get_memos(file_path)
  File.open(file_path) { |file| JSON.parse(file.read) }
end

def set_memos(file_path, memos)
  File.open(file_path, 'w') { |file| JSON.dump(memos, file) }
end

get '/' do
  erb :home, layout: :layout
end

get '/memos' do
  @memos = get_memos(FILE_PATH)
  erb :memos, layout: :layout
end

get '/memos/new' do
  erb :new, layout: :layout
end

get '/memos/:id' do
  memos = get_memos(FILE_PATH)
  @id = params[:id]
  @title = memos[@id]['title']
  @content = memos[@id]['content']

  erb :show, layout: :layout
end

post '/memos' do
  title = CGI.escapeHTML(params[:title])
  content = CGI.escapeHTML(params[:content])

  memos = get_memos(FILE_PATH)
  id = memos.empty? ? 1 : (memos.keys.map(&:to_i).max + 1).to_s
  memos[id] = { 'title' => title, 'content' => content }
  set_memos(FILE_PATH, memos)

  redirect "/memos/#{id}"
end

get '/memos/:id/edit' do
  memos = get_memos(FILE_PATH)
  @id = params[:id]
  @title = memos[@id]['title']
  @content = memos[@id]['content']

  erb :edit, layout: :layout
end

patch '/memos/:id' do
  title = CGI.escapeHTML(params[:title])
  content = CGI.escapeHTML(params[:content])
  id = params[:id]

  memos = get_memos(FILE_PATH)
  memos[id] = { 'title' => title, 'content' => content }
  set_memos(FILE_PATH, memos)

  redirect "/memos/#{id}"
end

delete '/memos/:id' do
  id = params[:id]

  memos = get_memos(FILE_PATH)
  memos.delete(id)
  set_memos(FILE_PATH, memos)

  redirect '/memos'
end

not_found do
  erb :notfound, layout: :layout
end
