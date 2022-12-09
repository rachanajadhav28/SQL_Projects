SELECT * FROM portfolioproject..IPL_Dataset

select * from portfolioproject..IPL_Dataset
	where Season is not null
	order by ID asc


-- Q.1) In which year csk wins final 

SELECT ID, City, Year(Date) as Year ,  MatchNumber,Venue, Team1, Team2, WinningTeam
FROM portfolioproject..IPL_Dataset
	WHERE WinningTeam = 'Chennai Super Kings'
		--AND  Season is not null
			AND MatchNumber = 'Final'
	order by ID asc

-- Q.2) How many times csk wins in  specific years

Drop Table If Exists Csk2021
create table Csk2021
(ID int,
City nvarchar(50),
Year int,
Month int,
Day int,
WinningTeam nvarchar(50))

Insert into Csk2021
SELECT  ID, City, YEAR(Date) as Year , MONTH(Date) as Month, DAY(Date) as Day 
	,WinningTeam	
		FROM portfolioproject..IPL_Dataset 
				where WinningTeam = 'Chennai Super Kings' and Year(Date) in (2008, 2010, 2011, 2015, 2019, 2021)
	group by ID, City, YEAR(Date) , MONTH(Date), DAY(Date), WinningTeam

select * from Csk2021


select Year, count(WinningTeam) as CskWin
	from Csk2021
		group by Year;



-- Q.3) Making point table for 2021 year

DROP PROCEDURE if exists [Point_Table]
GO
create procedure  Point_Table 
as
with PointTable as
(select Year(Date) as Year, MatchNumber, Team1 as Team, IIf(Team1 = WinningTeam, 2,0) as PT
	from portfolioproject..IPL_Dataset
	where Year(Date) = '2021'
		UNION 
		select year(Date) as Year,  MatchNumber, Team2 as Team, IIf(Team2 = WinningTeam, 2,0) as PT
	from portfolioproject..IPL_Dataset
	where Year(Date) = '2021')

select Team , count(*) as Matches,
sum(IIF(PT = 2,1,0)) as Wins,
sum(IIF(PT = 0,1,0)) as Loss,
sum(PT) as Points from PointTable
group by Team
order by Points desc
Go

exec Point_Table


-- Q.4) How Many Times CSK , MI, DC wins in specific year
	
Drop Table If Exists TeamWins
create table TeamWins
(ID int,
City nvarchar(50),
Year int,
Month int,
Day int,
WinningTeam nvarchar(50))

Insert into TeamWins 			
SELECT  ID, City, YEAR(Date) as Year , MONTH(Date) as Month, DAY(Date) as Day 
	,WinningTeam	
		FROM portfolioproject..IPL_Dataset 
				where WinningTeam in ('Chennai Super Kings', 'Mumbai Indians', 'Delhi Capitals') 
					and Year(Date) in (2010, 2011, 2015, 2019, 2021)
	group by ID, City, YEAR(Date) , MONTH(Date), DAY(Date), WinningTeam

select * from TeamWins

select Year, WinningTeam, count(WinningTeam) as Team
	from TeamWins
		group by Year, WinningTeam;


SELECT Id, City, year(Date), MONTH(Date), DAY(Date), Team1 , Team2, WinningTeam, Player_of_Match 
	 from portfolioproject..IPL_Dataset
		where year(Date) in (2021)
			


SELECT * FROM portfolioproject..IPL_Dataset

select  distinct(WinningTeam), IIF(WinningTeam = 'Chennai Super Kings', 1 ,0) as TeamNumber
	from portfolioproject..IPL_Dataset


-- ## ANALYSING IPL BALL BY BALL DATA FOR 2021 SEASON
select * from portfolioproject..Ball_By_Ball


drop table if exists Player
create table Player
	(match_id int,
	 match_name nvarchar(255),
	 inning_no int,
	 batting_team nvarchar(255),
	 overs float,
	 over_id int,
	 batsman nvarchar(255),
	 non_striker nvarchar(255))

	 Insert into Player
		select match_id, match_name,inning_no, batting_team, overs, over_id, batsman,non_striker
			from portfolioproject..Ball_By_Ball

select * from Player


drop table if exists Batsman_scored
create table Batsman_scored
(match_id int,
match_name nvarchar(255),
inning_no int,
overs float,
over_id int,
batting_tean nvarchar(255),
batsman nvarchar(255),
bowler nvarchar(255),
extra_runs int,
batsman_runs int,
total_runs int ,
extras nvarchar(255))

insert into Batsman_scored
select match_id, match_name, inning_no, overs,over_id, batting_team, 
	batsman, bowler,extra_runs, batsman_run, total_runs, extras
	from portfolioproject..Ball_By_Ball

select * from Batsman_scored



drop table if exists Player_Out
create table Player_Out
(match_id int,
match_name nvarchar(255),
inning_no int,
overs float,
over_id int,
batting_team nvarchar(255),
bowling_team nvarchar(255),
bowler nvarchar(255),
player_out nvarchar(255),
elimination_kind nvarchar(255),
fielders_caught nvarchar(255))
	insert into Player_Out
		select match_id, match_name, inning_no, overs, over_id, batting_team, 
		bowling_team, bowler, player_out, elimination_kind, fielders_caught
	from portfolioproject..Ball_By_Ball

select * from Player_Out


drop table if exists Winner
create table Winner 
(match_id int,
match_name nvarchar(255),
batsman nvarchar(255),
winner nvarchar(255),
player_of_match nvarchar(255),
city nvarchar(255),
venue nvarchar(255))
 insert into Winner
		select match_id, match_name, batsman, winner, player_of_match, city, venue
	from portfolioproject..Ball_By_Ball

select * from Winner

-- overall Runs in t20 ipl 2021 season

drop table if exists OverallRuns
create table OverallRuns
(match_id int,
batsman nvarchar(255),
Runs int)
insert into OverallRuns
select 
	a.match_id,
	b.batsman,
		sum(c.total_runs) as Runs
	from Player a
		join portfolioproject..Ball_By_Ball b 
	on concat(a.match_id, a.inning_no, a.overs)
		= concat(b.match_id, b.inning_no, b.overs)
	join  Batsman_scored c
		on a.batsman = c.batsman
			group by a.match_id, b.batsman
		having sum(c.total_runs) >=100
	order by Runs Desc


select  distinct(batsman), Runs
	from OverallRuns
		order by Runs desc

-- Players with most centuries in ipl 2021 season

select batsman, count(*) as Centuries
	from OverallRuns
	group by batsman, Runs
	order by centuries desc


-- Highest Wicket Takers in ipl season 2021

Drop table if exists HighWicketTakers
create table HighWicketTakers
(bowler nvarchar(255),
player_out nvarchar(255),
Wickets_Taken int)
	insert into HighWicketTakers
	select b.bowler, b.player_out, count(*) as Wickets_Taken
		from portfolioproject..Ball_By_Ball a 
			join  Player_Out b
				on concat(a.match_id, a.inning_no, a.overs)
			= concat(b.match_id, b.inning_no, b.overs)
			join batsman_scored c 
				on a.bowler = c.bowler
				where b.elimination_kind is not null 
				and b.player_out is not null
					group by b.bowler, b.player_out
					order by Wickets_Taken desc

select bowler, count(player_out) as wickets 
	from HighWicketTakers
	group by bowler
	order by wickets desc

-- BOWLERS ECONOMY

select * from(select* from
(select  a.bowler, 
		count(b.over_id) as Balls,
		sum(b.batsman_runs) + sum(b.extra_runs) as Runs_Given ,
		((sum(b.batsman_runs) + sum(b.extra_runs))/ count(*))*6 as Economy
	from portfolioproject..Ball_By_Ball a
	join Batsman_Scored b
	on a.bowler = b.bowler
	where b.overs <= 20 
	group by a.bowler) as t1
	where t1.Balls >= 180 ) as t2 
	order by Runs_Given, Economy desc

-- WHICH BOWLERS GIVES MAXIMUM DOT BALLS

Select * from 
	(select a.bowler,
		count(distinct a.match_id) as Matches,
		count(b.batsman_runs) as Dots,
		count(b.batsman_runs)/count(distinct a.match_id) as dots_per_match
		from portfolioproject..Ball_By_Ball a 
		join Batsman_scored b
		on a.match_id = b.match_id
		where a.batsman_run not in (1,2,3,4,5,6) and  b.extras not in ('wides', 'noballls')
		and a.overs < 21 
		group by a.bowler) as t1 
		where Dots > 60 
		order by dots_per_match desc


-- players have most sixes in ipl 2021 season


select batsman, count(Batsman_runs) as Sixes
	from Batsman_scored
		where batsman_runs = 6
		group by batsman
	order by Sixes desc


-- players have most fours in ipl 2021 season

select batsman, count(Batsman_runs) as Fours
	from Batsman_scored
		where batsman_runs = 4
		group by batsman
	order by Fours desc

-- sixes scored by Ravindra Jadeja in Wankhede stadium Mumbai

select  batsman, count(batsman_run) as Sixes
	from portfolioproject..Ball_By_Ball
		where batsman_run = 6 
		and  batsman = 'RA Jadeja' 
		and venue = 'Wankhede Stadium, Mumbai'
		group by batsman
	order by Sixes desc









