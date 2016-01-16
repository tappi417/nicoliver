# -*- coding: utf-8 -*-
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
