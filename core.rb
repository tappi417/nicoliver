# -*- coding: utf-8 -*-
require 'uri'
require 'open-uri'
require 'nokogiri'


# チャンネルページデータを取得　
url = URI.parse('http://ch.nicovideo.jp/amiami-ch')
doc = Nokogiri::HTML(open(url))

doc.css('.p-live-body').each do |title|
  puts title.content.gsub(/(\s)+/, '')
end

