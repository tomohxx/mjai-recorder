\echo *************************************************************
\echo * Mjai Recoder Report (`date`)
\echo * :NAME
\echo *************************************************************

\pset footer
\echo

select
count(*) as 試合数,
round(avg(players.position), 3) as 平均順位,
round(avg(players.score), 0) as 平均最終持ち点,
round(count(case when players.position = 1 then 1 else null end)::numeric / nullif(count(*), 0), 3) as 一位率,
round(count(case when players.position = 2 then 1 else null end)::numeric / nullif(count(*), 0), 3) as 二位率,
round(count(case when players.position = 3 then 1 else null end)::numeric / nullif(count(*), 0), 3) as 三位率,
round(count(case when players.position = 4 then 1 else null end)::numeric / nullif(count(*), 0), 3) as 四位率,
round(count(case when players.seat = 0 then 1 else null end)::numeric / nullif(count(*), 0), 3) as 東家率,
round(count(case when players.seat = 1 then 1 else null end)::numeric / nullif(count(*), 0), 3) as 南家率,
round(count(case when players.seat = 2 then 1 else null end)::numeric / nullif(count(*), 0), 3) as 西家率,
round(count(case when players.seat = 3 then 1 else null end)::numeric / nullif(count(*), 0), 3) as 北家率
from players
inner join games
on players.game_id = games.id
  and not games.error_flag
where players.player_name = :'NAME';

select
count(*) as 局数,
round(count(actors.id)::numeric / nullif(count(*), 0), 3) as 和了率,
round(count(case when actors.actor_id = actors.target_id then 1 else null end)::numeric / nullif(count(actors.id), 0), 3) as 自摸率,
round(count(case when targets.actor_id <> targets.target_id then 1 else null end)::numeric / nullif(count(*), 0), 3) as 放銃率,
round(avg(actors.delta), 0) as 平均得点,
round(avg(case when targets.actor_id <> targets.target_id then targets.delta else null end), 0) as 平均失点,
round(count(riichis.id)::numeric / nullif(count(*), 0), 3) as 立直率,
round(count(nakis_.actor_id)::numeric / nullif(count(*), 0), 3) as 副露率,
round(count(ryukyokus.id)::numeric / nullif(count(*), 0), 3) as 流局率,
round(count(case when ryukyokus.tenpai then 1 else null end)::numeric / nullif(count(ryukyokus.id), 0), 3) as 流局時聴牌率
from rounds
inner join players
on rounds.game_id = players.game_id
  and players.player_name = :'NAME'
inner join games
on rounds.game_id = games.id
  and not games.error_flag
left outer join winnings as actors
on rounds.id = actors.round_id
  and players.id = actors.actor_id
left outer join winnings as targets
on rounds.id = targets.round_id
  and players.id = targets.target_id
left outer join riichis
on rounds.id = riichis.round_id
  and players.id = riichis.player_id
left outer join (
  select distinct
  actor_id, round_id
  from nakis
) as nakis_
on rounds.id = nakis_.round_id
  and players.id = nakis_.actor_id
left outer join ryukyokus
on rounds.id = ryukyokus.round_id
  and players.id = ryukyokus.player_id;
