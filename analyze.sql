\echo *************************************************************
\echo *** Mjai Recoder Report (`date`) ***
\echo *************************************************************

\pset footer

create view my_winnings(actor, target) as select actor, target from winnings inner join players on winnings.actor = players.id where players.name = :'NAME';
create view my_ryukyokus(tenpai) as select tenpai from ryukyokus inner join players on ryukyokus.player_id = players.id where players.name = :'NAME';

select count(*) as 試合数 from games inner join players on games.id = players.game_id where players.name = :'NAME';
select count(*) as 局数 from rounds inner join players on rounds.game_id = players.game_id where players.name = :'NAME';
\gset
select round(count(*)::numeric/:局数, 3) as 和了率 from my_winnings;
select round(count(*)::numeric/(select count(*) from my_winnings), 3) as 自摸率 from my_winnings where my_winnings.actor = my_winnings.target;
select round(avg(winnings.delta), 0) as 平均得点 from winnings inner join players on winnings.actor = players.id where players.name = :'NAME';
select round(avg(winnings.delta), 0) as 平均失点 from winnings inner join players on winnings.actor != players.id and winnings.target = players.id where players.name = :'NAME';
select round(count(*)::numeric/:局数, 3) as 放銃率 from winnings inner join players on winnings.target = players.id where winnings.actor != players.id and players.name = :'NAME';
select round(count(*)::numeric/:局数, 3) as 立直率 from riichis inner join players on riichis.player_id = players.id where players.name = :'NAME';
select round(count(*)::numeric/:局数, 3) as 副露率 from (select distinct nakis.actor, nakis.round_id from nakis inner join players on nakis.actor = players.id where players.name = :'NAME') as foo;
select ranking.position as 順位, count(ranking.position) as 回数 from (select results.position from results inner join players on results.player_id = players.id where players.name = :'NAME') as ranking group by ranking.position order by ranking.position;
select round(avg(results.position), 3) as 平均順位 from results inner join players on results.player_id = players.id where players.name = :'NAME';
select round(count(*)::numeric/:局数, 3) as 流局率 from ryukyokus inner join players on ryukyokus.player_id = players.id where players.name = :'NAME';
select round(count(*)::numeric/(select count(*) from my_ryukyokus), 3) as 流局時聴牌率 from my_ryukyokus where my_ryukyokus.tenpai;

drop view my_winnings;
drop view my_ryukyokus;
