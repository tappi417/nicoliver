# -*- coding: utf-8 -*-
require 'sqlite3'

# データベース操作クラス
class SQLExcecutor

  def initialize()
    @db = SQLite3::Database.new("data.db")
  end

  # insert
  def insert_channel(channel)
    @db.execute("insert into channel values(?, ?)",  channel.channel_url, channel.channel_title)
  end

  # delete
  def delete_channel(channel)
    @db.execute("delete from channel where channel_url = ?", channel.channel_url)
  end

  # select
  def get_channel_url()
    result = Array.new
    @db.execute("select channel_url from channel") do |row|
      result << row[0]
    end
    return result
  end

  # insert live
  def insert_live(live)
    @db.execute("insert into live values(?, ?, ?, ?)", live.channel_url, live.live_url, live.live_title, live.broadcast_date.to_s)
  end

  # count live
  def count_live(live)
    count =  @db.execute("select count(live_url) from live where channel_url = ? and live_url = ?", live.channel_url, live.live_url)
    return count[0][0]
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
    @live_url = ""
    @live_title = ""
    @broadcast_date = "" # Datetimeで扱う
  end
end
