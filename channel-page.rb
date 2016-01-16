# -*- coding: utf-8 -*-
require 'sqlite3'

# データベース操作クラス
class SQLExcecutor

  def initialize()
    @db = SQLite3::Database.new("data.db")
  end

  #insert
  def insert_channel(channel)
    @db.execute("insert into channel values(?, ?)",  channel.channel_url, channel.channel_title)
  end

  #delete
  def delete_channel(channel)
    @db.execute("delete from channel where channel_url = ?", channel.channel_url)
  end

end

# チャンネルページのデータクラス
class Channel
  attr_accessor :channel_url, :channel_title, :lives
  def initialize(channel_url)
    @channel_url = channel_url
    @channel_title = ""
    @lives = Array.new
  end


  #select

end

# 生放送のデータクラス
class Live
  attr_accessor :channel_url, :live_url, :live_title, :broadcast_date
  def initialize
    @channel_url = ""
    @live_title = ""
    @live_url = ""
    @broadcast_date = "" # Datetimeで扱う
  end
end
