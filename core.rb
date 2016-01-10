# -*- coding: utf-8 -*-
require 'uri'
require 'open-uri'
require 'nokogiri'
require 'date'

# チャンネルページのデータクラス
class ChannelContent
  attr_accessor :channel_url, :live_contents
  def initialize(channel_url)
    @channel_url = channel_url
    @live_contents = Array.new
  end
end

# 生放送のデータクラス
class LiveContent
  attr_accessor :title, :live_url, :broadcast_date
  def initialize
    @title = ""
    @live_url = ""
    # Datetimeで扱う
    @broadcast_date = ""
  end
end

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
def aquire_content(pageurl)
  url = URI.parse(pageurl)
  doc = Nokogiri::HTML(open(url))

  channel_content = ChannelContent.new(pageurl)
  doc.css('.p-live-body').each do |live|
    live_content = LiveContent.new
    # タイトル，リンク取得（ループするが1つのみ取得できる想定)
    live.css('.g-live-title').each do |title|
      live_content.title = title.content.gsub(/(\s)+/, '')
      title.css('a').each do |anchor|
        live_content.live_url = anchor['href']
      end
      channel_content.live_contents << live_content
    end
    # 放送日取得
    live.css('.g-live-airtime').each do |date|
      live_content.broadcast_date = format_date(date.content)
    end
  end
  return channel_content
end

# 各チャンネルページのデータを取得
urls = Array['http://ch.nicovideo.jp/amiami-ch',
             'http://ch.nicovideo.jp/imas-station',
             'http://ch.nicovideo.jp/MillionRADIO',
             'http://ch.nicovideo.jp/cinderellaparty',
             'http://ch.nicovideo.jp/lulucan-himitsu']

urls.each do |url|
  channel_content = aquire_content(url)
  channel_content.live_contents.each do |live|
    # 放送日を迎えていない生放送のみ表示
    if (live.broadcast_date > DateTime.now)
      puts live.title + ": " + live.live_url + "(" + live.broadcast_date.strftime("%Y/%m/%d %a.") + ")"
    end
  end
end

