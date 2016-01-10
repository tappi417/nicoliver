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
  @title
  @live_url
  @broadcast_date
end


# チャンネルページデータを取得
def aquire_content(pageurl)
  url = URI.parse(pageurl)
  doc = Nokogiri::HTML(open(url))

  channel_content = ChannelContent.new
  doc.css('.p-live-body').each do |live|
    # 生放送データ取得(タイトル，リンク取得でループするが1つのみ取得できる想定)
    live.css('.g-live-title').each do |title|
      live_content = LiveContent.new
      live_content.title = title.content.gsub(/(\s)+/, '')
      title.css('a').each do |anchor|
        live_content.live_url = anchor['href']
      end
      channel_content.live_contents << live_content
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
    puts live.title + ": " + live.live_url
  end
end

