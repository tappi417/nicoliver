# -*- coding: utf-8 -*-
require ('./channel-page.rb')
require 'uri'
require 'open-uri'
require 'nokogiri'
require 'date'

# 放送日の生データを加工
def format_date(raw_date)
  date = raw_date.gsub(/(\s)+|放送予定|放送終了|/, '')
  now_date = DateTime.now

  month = date[0, 2].to_i
  day = date[3, 2].to_i
  hour = date[5, 2].to_i
  minutes = date[8, 2].to_i

  # 現在が12月で取得した月が1月の場合
  if (now_date.month == 12 && month == 1)
    year = now_date.year + 1
  # 現在が1月で取得した月が12月の場合
  elsif (now_date.month == 1 && month == 12)
    year = now_date.year - 1
  else
    year = now_date.year
  end

  return DateTime.new(year, month, day, hour, minutes, 00)
end

# チャンネルページデータを取得
def acquire_content(pageurl)
  url = URI.parse(pageurl)
  doc = Nokogiri::HTML(open(url))

  channel = Channel.new(pageurl)
  # チャンネル名取得
  doc.css('.channel_name').each do |name|
    channel.channel_title = name.content
  end

  begin
    doc.css('.p-live-body').each do |lives|
      live = Live.new
      live.channel_url = pageurl
      # タイトル，リンク取得（ループするが1つのみ取得できる想定)
      lives.css('.g-live-title').each do |title|
        live.live_title = title.content.gsub(/(\s)+/, '')
        title.css('a').each do |anchor|
          live.live_url = anchor['href']
        end
      end
      # 放送日取得
      lives.css('.g-live-airtime').each do |date|
        live.broadcast_date = format_date(date.content)
      end
      channel.lives << live
    end
  rescue
    puts "can't get live info:" + channel.channel_title
  end
  return channel
end

# 生放送情報を取得済みであるかチェックする
# 取得済みでなければデータベースに登録する
def check_acquired_live(excecutor, live)
  if (excecutor.count_live(live) > 0)
    return true
  else
    excecutor.insert_live(live)
    return false
  end

end

# main
excecutor = SQLExcecutor.new()
if (ARGV != nil && ARGV.size == 1 && ARGV[0] == "-l")
  excecutor.get_channel_url().each do |url|
    puts url
  end
  exit
elsif (ARGV != nil && ARGV.size == 2 && ARGV[0] == "-a")
  channel = acquire_content(ARGV[1])
  excecutor.insert_channel(channel)
  exit
elsif (ARGV != nil && ARGV.size == 2 && ARGV[0] == "-d")
  channel = Channel.new(ARGV[1])
  excecutor.delete_channel(channel)
  exit
end


# 各チャンネルページのデータを取得
excecutor = SQLExcecutor.new()
urls = excecutor.get_channel_url()
urls.each do |url|
  channel = acquire_content(url)
  channel.lives.each do |live|
    # 生放送情報が既に取得済みであるかチェック
    has_acquired = check_acquired_live(excecutor, live)
    # 放送日を迎えていない生放送のみ表示
    if (live.broadcast_date > DateTime.now && !has_acquired)
      puts live.live_title + ": "
      puts live.live_url
      puts "(" + live.broadcast_date.strftime("%Y/%m/%d %a.") + ")"
    end
  end
end

