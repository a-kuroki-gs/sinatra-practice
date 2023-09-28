# 「Sinatra を使ってWebアプリケーションの基本を理解する」の課題
## メモアプリの概要
- メモを追加、編集、削除
- 一覧の表示

## アプリケーションの立ち上げ手順
1. HTTPSのURLを`git clone` で取り込む
2. 上で取り込んだリポジトリ(`sinatra-practice`)に移動
3. (`main`ブランチにいる場合)`git checkout sinatra`を実行し、`sinatra`ブランチへ移動
  (まだ`main`ブランチにはマージしていないため)
4. `bundle install`を実行し必要な`gem`をインストール
5. `bundle exec ruby memoapp.rb`を実行
6. ブラウザで`http://localhost:4567`にアクセス
