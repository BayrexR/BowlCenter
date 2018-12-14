use s7jnv52ivalrzp26;


CREATE TABLE bowls (
  bowl_id int(11) NOT NULL AUTO_INCREMENT,
  bowl varchar(100) DEFAULT NULL,
  PRIMARY KEY (bowl_id)
) ENGINE=InnoDB AUTO_INCREMENT=128 DEFAULT CHARSET=latin1;

CREATE TABLE teams (
  team_id int(11) NOT NULL AUTO_INCREMENT,
  team varchar(100) DEFAULT NULL,
  PRIMARY KEY (team_id)
) ENGINE=InnoDB AUTO_INCREMENT=256 DEFAULT CHARSET=latin1;


CREATE TABLE games (
  game_id int(11) NOT NULL,
  year int(11) DEFAULT NULL,
  bowl_id int(11) DEFAULT NULL,
  home_team_id int(11) DEFAULT NULL,
  away_team_id int(11) DEFAULT NULL,
  home_score int(11) DEFAULT NULL,
  away_score int(11) DEFAULT NULL,
  PRIMARY KEY (game_id),
  KEY game_fk01_idx (bowl_id),
  KEY game_fk02_idx (home_team_id),
  KEY game_fk03_idx (away_team_id),
  CONSTRAINT game_fk01 FOREIGN KEY (bowl_id) REFERENCES bowls (bowl_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT game_fk02 FOREIGN KEY (home_team_id) REFERENCES teams (team_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT game_fk03 FOREIGN KEY (away_team_id) REFERENCES teams (team_id) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE import_game_stats (
  gameid int(11) NOT NULL,
  year int(11) DEFAULT NULL,
  away_team varchar(100) DEFAULT NULL,
  home_team varchar(100) DEFAULT NULL,
  bowl varchar(100) DEFAULT NULL,
  home_bowl_scores int(11) DEFAULT NULL,
  away_bowl_scores int(11) DEFAULT NULL,
  winning_team varchar(100) DEFAULT NULL,
  losing_team varchar(100) DEFAULT NULL,
  PRIMARY KEY (gameid)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE import_player_stats (
  playerId int(11) NOT NULL AUTO_INCREMENT,
  gameId int(11) DEFAULT NULL,
  team varchar(100) DEFAULT NULL,
  player varchar(100) DEFAULT NULL,
  PRIMARY KEY (playerId)
) ENGINE=InnoDB AUTO_INCREMENT=19997 DEFAULT CHARSET=latin1;


CREATE TABLE players (
  player_id int(11) NOT NULL AUTO_INCREMENT,
  game_id int(11) DEFAULT NULL,
  team_id int(11) DEFAULT NULL,
  player varchar(100) DEFAULT NULL,
  PRIMARY KEY (player_id),
  KEY players_fk01_idx (game_id),
  KEY players_fk02_idx (team_id),
  CONSTRAINT players_fk01 FOREIGN KEY (game_id) REFERENCES games (game_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT players_fk02 FOREIGN KEY (team_id) REFERENCES teams (team_id) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=13858 DEFAULT CHARSET=latin1;


CREATE TABLE flsk_bowl_history (
  bowl_id int(11) NOT NULL PRIMARY KEY,
  bowl varchar(100) DEFAULT NULL,
  cnt_games bigint(21) NOT NULL DEFAULT '0',
  min_year bigint(11) DEFAULT NULL,
  max_year bigint(11) DEFAULT NULL,
  home_teams text,
  away_teams text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE flsk_bowl_outcome (
  game_id int(11) NOT NULL primary key ,
  year int(11) DEFAULT NULL,
  bowl varchar(100) DEFAULT NULL,
  home_team varchar(100) DEFAULT NULL,
  away_team varchar(100) DEFAULT NULL,
  home_score int(11) DEFAULT NULL,
  away_score int(11) DEFAULT NULL,
  winning_team varchar(100) DEFAULT NULL,
  loosing_team varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE flsk_bowl_players (
  player_id bigint(11) NOT NULL PRIMARY KEY,
  year int(11) DEFAULT NULL,
  bowl varchar(100) DEFAULT NULL,
  team varchar(100) DEFAULT NULL,
  player varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



---------------------------------------------------------
create or replace view s7jnv52ivalrzp26.years_vw as
select  distinct year 
from    s7jnv52ivalrzp26.games
order by year;


create or replace view s7jnv52ivalrzp26.teams_vw as
select  t.team,  ( select count(1) 
                   from   s7jnv52ivalrzp26.games g 
                   where  g.home_team_id = t.team_id 
                      or  g.away_team_id = t.team_id ) as cnt_games
from    s7jnv52ivalrzp26.teams t
;


create or replace view s7jnv52ivalrzp26.bowls_vw as
select  bowl
from    s7jnv52ivalrzp26.bowls
;


create or replace view games_vw as
select g.game_id,
       g.year,
       g.bowl_id,
       b.bowl,
       th.team as home_team,
       ta.team as away_team,
       g.home_score,
       g.away_score,
       case when g.home_score > g.away_score then th.team else ta.team end as winning_team,
       case when g.home_score < g.away_score then th.team else ta.team end as loosing_team       
from   s7jnv52ivalrzp26.games g
join   s7jnv52ivalrzp26.bowls b  on g.bowl_id = b.bowl_id
join   s7jnv52ivalrzp26.teams th on g.home_team_id = th.team_id
join   s7jnv52ivalrzp26.teams ta on g.away_team_id = ta.team_id
;


create or replace view players_vw as
select p.player_id, g.year, b.bowl, t.team, p.player
from   s7jnv52ivalrzp26.players p
join   s7jnv52ivalrzp26.games   g  on p.game_id = g.game_id
join   s7jnv52ivalrzp26.bowls   b  on g.bowl_id = b.bowl_id
join   s7jnv52ivalrzp26.teams   t  on p.team_id = t.team_id
;

create or replace view bowl_history_vw as
select bowl_id,
       bowl, 
       count(1) as cnt_games,
       min(year) as min_year,
       max(year) as max_year,
       group_concat(distinct home_team order by home_team separator ', ') home_teams,
       group_concat(distinct away_team order by away_team separator ', ') away_teams       
from games_vw x
group by bowl
order by bowl
;

create or replace view bowl_outcome_vw as
select game_id,
       year,
       bowl, 
       home_team,
       away_team,
       home_score,
       away_score,
       winning_team,
       loosing_team
from games_vw x
order by bowl
;

create or replace view bowl_players_vw as
select  min(player_id) as player_id,
        year,
        bowl,
        team,
        player
from    players_vw 
group by year, bowl, team, player
order by team, player
;





------------------------------------------------
delete  
  from    s7jnv52ivalrzp26.import_player_stats
  where   gameid not in ( select gameid from s7jnv52ivalrzp26.import_game_stats);
  
------------------------------------------------
insert into s7jnv52ivalrzp26.bowls(bowl)
  select distinct bowl
  from   s7jnv52ivalrzp26.import_game_stats
  order by bowl;
--------------------------------------------
insert into s7jnv52ivalrzp26.teams(team)
  select home_team as team 
  from   s7jnv52ivalrzp26.import_game_stats
  union 
  select away_team as team 
  from   s7jnv52ivalrzp26.import_game_stats
  order by team;
----------------------------------------
insert into s7jnv52ivalrzp26.games
  select g.gameid as game_id,
         g.year,
         ( select x.bowl_id from bowls x where x.bowl = g.bowl ) as bowl_id,	   
         ( select x.team_id from teams x where x.team = g.home_team ) as home_team_id,
         ( select x.team_id from teams x where x.team = g.away_team ) as away_team_id,
         g.home_bowl_scores as home_score,    
         g.away_bowl_scores as away_score
  from   s7jnv52ivalrzp26.import_game_stats g;
---------------------------------------
insert into s7jnv52ivalrzp26.players
  select ps.playerid as player_id,
         ps.gameid   as game_id,
         ( select x.team_id from teams x where x.team = ps.team ) as team_id,
         player
  from   s7jnv52ivalrzp26.import_player_stats ps;
-------------------------------------------
insert into flsk_bowl_history 
  select * from bowl_history_vw;
  
  insert into flsk_bowl_outcome 
  select * from bowl_outcome_vw;
  
  insert into flsk_bowl_players 
  select * from bowl_players_vw; 