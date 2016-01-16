# nicoliver
ニコニコ生放送の予約を忘れないためのアプリケーションを作成予定

## Usage
`ruby core.rb` 登録済みチャンネルの生放送予定を表示
`ruby core.rb -l` 登録済みチャンネルのリストを表示
`ruby core.rb -a <URL>` 指定したURLのチャンネルを登録
`ruby core.rb -d <URL>` 指定したURLのチャンネルを削除

## 必要なgem
* nokogiri
* SQLite3

## 追加予定機能
* 予約開始通知機能
* チェック対象チャンネル追加・削除
