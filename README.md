# 「WebアプリからのDB利用」の課題
## メモアプリの概要
- メモを追加、編集、削除
- 一覧の表示

## アプリケーションの立ち上げ手順
1. HTTPSのURLを`git clone` で取り込む
2. 上で取り込んだリポジトリ(`sinatra-practice`)に移動
3. (`main`ブランチにいる場合)`git checkout db`を実行し、`db`ブランチへ移動
  (まだ`main`ブランチにはマージしていないため)
4. `bundle install`を実行し必要な`gem`をインストール
5. 以下を実行し、`memoapp`という名前のDBを作成
```
# postgresユーザでログイン
$ psql postgres
# DBの作成
postgres=# create database memoapp;
# postgresから抜ける
postgres=# \q
```
6. `psql memoapp`を実行し 5. で作成した`memoapp`DBに入る
7. 以下を実行し、`Memos`という名前のテーブルを作成
```
memoapp=# CREATE TABLE Memos
memoapp-#  (id integer NOT NULL,
memoapp(# title TEXT NOT NULL,
memoapp(# content TEXT NOT NULL,
memoapp(# PRIMARY KEY (id));
```
8. `bundle exec ruby memoapp.rb`を実行
9. ブラウザで`http://localhost:4567`にアクセス
