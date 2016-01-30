# nicoliver
ニコニコ生放送の予約を忘れないためのアプリケーションを作成予定

## 機能概要
* 予約したいチャンネルページの登録・削除
* 登録済みチャンネルページの一覧表示
* 登録済みチャンネルページでの開始前生放送の一覧取得  
※ただし，一度取得した生放送の情報は再度表示しない

## Usage
* `sh nicoliver` 登録済みチャンネルの生放送予定を表示
* `sh nicoliver -l` 登録済みチャンネルのリストを表示
* `sh nicoliver -a <URL>` 指定したURLのチャンネルを登録
* `sh nicoliver -d <URL>` 指定したURLのチャンネルを削除

## 必要なgem
* nokogiri
* SQLite3

## 追加予定機能
* 予約開始通知機能

