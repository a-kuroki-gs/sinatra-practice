# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'cgi'

conn = PG.connect(dbname: 'memoapp')

def read_memos(conn)
  result = conn.exec('SELECT * FROM Memos ORDER BY id')
  memos = {}
  result.each do |row|
    memos[row['id']] = {
      'title' => row['title'].force_encoding('UTF-8'),
      'content' => row['content'].force_encoding('UTF-8')
    }
  end
  memos
end

def read_memo_from_id(conn, id)
  memo =
    conn.exec_params(
      'SELECT * FROM Memos WHERE id=$1',
      [id]
    )

  title = memo.field_values('title')[0].force_encoding('UTF-8')
  content = memo.field_values('content')[0].force_encoding('UTF-8')

  [title, content]
end

def save_memos(conn, id, new_memo)
  conn.exec_params(
    'INSERT INTO Memos VALUES ($1, $2, $3)',
    [id, new_memo['title'], new_memo['content']]
  )
end

def update_memos(conn, id, new_memo)
  conn.exec_params(
    'UPDATE Memos SET title=$1, content=$2 WHERE id=$3',
    [new_memo['title'], new_memo['content'], id]
  )
end

def delete_memos(conn, id)
  conn.exec_params(
    'DELETE FROM Memos WHERE id=$1',
    [id]
  )
end

get '/' do
  erb :home, layout: :layout
end

get '/memos' do
  @memos = read_memos(conn)
  erb :memos, layout: :layout
end

get '/memos/new' do
  erb :new, layout: :layout
end

get '/memos/:id' do
  @id = params[:id]
  @title, @content = read_memo_from_id(conn, @id)

  erb :show, layout: :layout
end

post '/memos' do
  title = CGI.escapeHTML(params[:title])
  content = CGI.escapeHTML(params[:content])

  memos = read_memos(conn)
  id = memos.empty? ? 1 : (memos.keys.map(&:to_i).max + 1).to_s
  new_memo = { 'title' => title, 'content' => content }
  save_memos(conn, id, new_memo)

  redirect "/memos/#{id}"
end

get '/memos/:id/edit' do
  @id = params[:id]
  @title, @content = read_memo_from_id(conn, @id)

  erb :edit, layout: :layout
end

patch '/memos/:id' do
  title = CGI.escapeHTML(params[:title])
  content = CGI.escapeHTML(params[:content])
  id = params[:id]

  new_memo = { 'title' => title, 'content' => content }
  update_memos(conn, id, new_memo)

  redirect "/memos/#{id}"
end

delete '/memos/:id' do
  id = params[:id]

  delete_memos(conn, id)

  redirect '/memos'
end

not_found do
  erb :notfound, layout: :layout
end
