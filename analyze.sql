\echo *************************************************************
\echo * Mjai Recoder Report (`date`)
\echo * :NAME
\echo *************************************************************

\pset footer
\echo

select
count(*) as 試合数,
round(avg(results.position), 3) as 平均順位,
round(avg(results.score), 0) as 平均最終持ち点,
round(count(case when results.position = 1 then 1 else null end)::numeric / count(*), 3) as 一位率,
round(count(case when results.position = 2 then 1 else null end)::numeric / count(*), 3) as 二位率,
round(count(case when results.position = 3 then 1 else null end)::numeric / count(*), 3) as 三位率,
round(count(case when results.position = 4 then 1 else null end)::numeric / count(*), 3) as 四位率,
round(count(case when players.seat = 0 then 1 else null end)::numeric / count(*), 3) as 東家率,
round(count(case when players.seat = 1 then 1 else null end)::numeric / count(*), 3) as 南家率,
round(count(case when players.seat = 2 then 1 else null end)::numeric / count(*), 3) as 西家率,
round(count(case when players.seat = 3 then 1 else null end)::numeric / count(*), 3) as 北家率
from results
inner join players
on results.player_id = players.id
inner join player_names
on players.player_name_id = player_names.id
where player_names.player_name = :'NAME';

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
from (
  select
  rounds.id as round_id,
  players.id as player_id
  from rounds
  inner join games
  on rounds.game_id = games.id
  inner join players
  on players.game_id = games.id
  inner join player_names
  on players.player_name_id = player_names.id
  where player_names.player_name = :'NAME'
) as participated
left outer join winnings as actors
on participated.round_id = actors.round_id
  and participated.player_id = actors.actor_id
left outer join winnings as targets
on participated.round_id = targets.round_id
  and participated.player_id = targets.target_id
left outer join riichis
on participated.round_id = riichis.round_id
  and participated.player_id = riichis.player_id
left outer join (
  select distinct
  actor_id, round_id
  from nakis
) as nakis_
on participated.round_id = nakis_.round_id
  and participated.player_id = nakis_.actor_id
left outer join ryukyokus
on participated.round_id = ryukyokus.round_id
  and participated.player_id = ryukyokus.player_id;
