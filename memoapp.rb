# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/json'
require 'cgi'

FILE_PATH = 'memoapp.json'

def read_memos
  File.open(FILE_PATH) { |file| JSON.parse(file.read) }
end

def save_memos(memos)
  File.open(FILE_PATH, 'w') { |file| JSON.dump(memos, file) }
end

def read_memo_from_id(id)
  memos = File.open(FILE_PATH) { |file| JSON.parse(file.read) }

  title = memos[id]['title']
  content = memos[id]['content']

  [title, content]
end

get '/' do
  erb :home, layout: :layout
end

get '/memos' do
  @memos = read_memos
  erb :memos, layout: :layout
end

get '/memos/new' do
  erb :new, layout: :layout
end

get '/memos/:id' do
  @id = params[:id]
  @title, @content = read_memo_from_id(@id)

  erb :show, layout: :layout
end

post '/memos' do
  title = CGI.escapeHTML(params[:title])
  content = CGI.escapeHTML(params[:content])

  memos = read_memos
  id = memos.empty? ? 1 : (memos.keys.map(&:to_i).max + 1).to_s
  memos[id] = { 'title' => title, 'content' => content }
  save_memos(memos)

  redirect "/memos/#{id}"
end

get '/memos/:id/edit' do
  @id = params[:id]
  @title, @content = read_memo_from_id(@id)

  erb :edit, layout: :layout
end

patch '/memos/:id' do
  title = CGI.escapeHTML(params[:title])
  content = CGI.escapeHTML(params[:content])
  id = params[:id]

  memos = read_memos
  memos[id] = { 'title' => title, 'content' => content }
  save_memos(memos)

  redirect "/memos/#{id}"
end

delete '/memos/:id' do
  id = params[:id]

  memos = read_memos
  memos.delete(id)
  save_memos(memos)

  redirect '/memos'
end

not_found do
  erb :notfound, layout: :layout
end
