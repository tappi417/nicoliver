-- テーブル削除
drop table channel;
drop table live;

-- テーブル作成
create table channel(
channel_url text primary key,
channel_title text
);

create table live(
channel_url text,
live_url text,
live_title text,
broadcast_date text,
primary key(channel_url, live_url)
);
