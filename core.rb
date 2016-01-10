# -*- coding: utf-8 -*-
require 'uri'
require 'open-uri'
require 'nokogiri'

# チャンネルページのデータクラス
class ChannelContent
  attr_accessor :live_contents
  def initialize
    @live_contents = Array.new
  end
end

# 生放送のデータクラス
class LiveContent
  attr_accessor :title, :live_url, :broadcast_date
  def initialize
    @title = ""
    @live_url = ""
    @broadcast_date = ""
  end
end

# 放送日の生データを加工
def format_date(raw_date)
  result = raw_date.gsub(/(\s)+|放送予定|放送終了|/, '')
  return result[0, 5] + " " + result[5, 13]
end

# チャンネルページデータを取得
def aquire_content(pageurl)
  url = URI.parse(pageurl)
  doc = Nokogiri::HTML(open(url))

  channel_content = ChannelContent.new
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
             'http://ch.nicovideo.jp/imas-station']

urls.each do |url|
  channel_content = aquire_content(url)
  channel_content.live_contents.each do |live|
    puts live.title + ": " + live.live_url + "(" + live.broadcast_date + ")"
  end
end

