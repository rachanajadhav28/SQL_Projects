SELECT * FROM salesreport..TATAMOTORS

-- Q.1) Find where tatamotors prev close is between 500 and 1000
select *
	 from salesreport..TATAMOTORS
		where Symbol = 'TATAMOTORS' AND [Prev Close] between 500 and 1000
		 AND Trades is not null
		 

--Q.2) Comparing The Data Per Year And Month.

select Symbol, Series, year(Date) as Year , month(Date) as Month, 
	sum([Open]) as SumOfOpen, sum(High) as SumOfHigh, sum(Low) as SumOfLow, 
		sum([Close]) as SumOfClose
			from salesreport..TATAMOTORS
		where year(Date) in (2000, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010) 
	and Symbol = 'TATAMOTORS'
group by Symbol, Series, year(Date) , month(Date)


select Symbol, Series, year(Date) as Year , month(Date) as Month, 
	sum([Open]) as SumOfOpen, 
		lag(sum([Open])) over (order by year(Date), month(Date)) as CompAsprevMonOpen , --## Compare as previous month open values
	sum(High) as SumOfHigh, 
		lag(sum(High)) over (order by year(Date), month(Date)) as CompAsprevMonHigh,   --## Compare as previous month high values
	sum(Low) as SumOfLow, 
		lag(sum(Low)) over (order by year(Date), month(Date)) as CompAsprevMonLow,     --## Compare as previous month low values
	sum([Close]) as SumOfClose, 
		lag(sum([Close])) over (order by year(Date), month(Date)) as CompAsprevMonClose   --## Compare as previous month close values
	  from salesreport..TATAMOTORS
		where year(Date) in (2000, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010) 
		and Symbol = 'TATAMOTORS'
	group by Symbol, Series, year(Date) , month(Date)


select Symbol, Series, year(Date) as Year , month(Date) as Month, 
	sum([Open]) as SumOfOpen, 
		lag(sum([Open])) over (order by year(Date), month(Date)) as CompAsprevMonOpen , --## Compare as previous month open values
	sum(High) as SumOfHigh, 
		lag(sum(High)) over (order by year(Date), month(Date)) as CompAsprevMonHigh,   --## Compare as previous month high values
	sum(Low) as SumOfLow, 
		lag(sum(Low)) over (order by year(Date), month(Date)) as CompAsprevMonLow,     --## Compare as previous month low values
	sum([Close]) as SumOfClose, 
		lag(sum([Close])) over (order by year(Date), month(Date)) as CompAsprevMonClose   --## Compare as previous month close values
	  from salesreport..TATAMOTORS
			where year(Date) in (2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021) 
		and Symbol = 'TATAMOTORS'
	group by Symbol, Series, year(Date) , month(Date)




SELECT * FROM salesreport..TATAMOTORS

-- Q 3) TEMP TABLE FROM YEAR 2000 TO 2010

DROP TABLE IF EXISTS TempSalesfrom_2000_2010
CREATE TABLE TempSalesfrom_2000_2010
(Symbol nvarchar(255),
Series nvarchar(255),
Year int,
Month int,
SumOfPrevClose float,
CompAsprevMonPrevClose float,
SumOfVolume float,
CompAsprevMonVol float,
 SumOfTurnover float,
 CompAsprevYearTurnover float,
 SumOfCTrades float,
 CompAsprevMontrades float)

 INSERT INTO TempSalesfrom_2000_2010
SELECT 
	 Symbol, Series, year(Date) as Year , month(Date) as Month, 
	sum([Prev Close]) as SumOfPrevClose, 
	lag(sum([Prev Close])) over (order by year(Date), month(Date)) as CompAsprevMonPrevClose , --## Compare as previous month OF PrevClose values
	sum(Volume) as SumOfVolume, 
	lag(sum(Volume)) over (order by year(Date), month(Date)) as CompAsprevMonVol,   --## Compare as previous month volume values
	sum(Turnover) as SumOfTurnover, 
	lag(sum(Turnover)) over (order by year(Date)) as CompAsprevYearTurnover,     --## Compare as previous month Turnover values
	sum(cast(Trades as float)) as SumOfCTrades, 
	lag(sum(cast(Trades as float))) over (order by year(Date), month(Date)) as CompAsprevMontrades  --## Compare as previous month Trades values
	  from salesreport..TATAMOTORS
		where year(Date) in (2000, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010) 
		and Symbol = 'TATAMOTORS'
	group by Symbol, Series, year(Date) , month(Date)


SELECT * FROM TempSalesfrom_2000_2010

--Q 4) TEMP TABLE FROM YEAR 2011 TO 2021

DROP TABLE IF EXISTS TempSalesFrom2011_2021
CREATE TABLE TempSalesFrom2011_2021
(Symbol nvarchar(255),
Series nvarchar(255),
Year int,
Month int,
SumOfPrevClose float,
CompAsprevMonPrevClose float,
SumOfVolume float,
CompAsprevMonVol float,
 SumOfTurnover float,
 CompAsprevYearTurnover float,
 SumOfTrades float,
 CompAsprevMontrades float)

INSERT INTO TempSalesFrom2011_2021
SELECT 
	Symbol, Series, year(Date) as Year , month(Date) as Month, 
		sum([Prev Close]) as SumOfPrevClose,
			lag(sum([Prev Close])) over (order by year(Date), month(Date)) as CompAsprevMonVol,
		sum(Volume) as SumOfVolume, 
			lag(sum(Volume)) over (order by year(Date), month(Date)) as CompAsprevMonVol,   --## Compare as previous month volume values
		sum(Turnover) as SumOfTurnover, 
			lag(sum(Turnover)) over (order by year(Date)) as CompAsprevYearTurnover,     --## Compare as previous month Turnover values
		sum(cast(Trades as float)) as SumOfTrades, 
			lag(sum(cast(Trades as float))) over (order by year(Date), month(Date)) as CompAsprevMontrades  --## Compare as previous month Trades values
		  from salesreport..TATAMOTORS
				where year(Date) in (2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021)  
			and Symbol = 'TATAMOTORS'
		group by Symbol, Series, year(Date) , month(Date)

SELECT * FROM TempSalesFrom2011_2021

-- Q 5) COMPARE THE TWO TABLES VALUES PER YEAR AND MONTH... WITH CTE(COMMON TABLE EXPRESSION)

SELECT * FROM salesreport..TCS

DROP TABLE IF EXISTS TATAMOTORS_TCSshares
CREATE TABLE TATAMOTORS_TCSshares
(Series nvarchar(255),
Symbol nvarchar(255),
TCS_Symbol nvarchar(255),
Year int,
Month int,
SumOfTataPrevClose float,
SumOfTCSPrevClose float,
CompAsPrevMonTataPrevclose float,
CompAsPrevMonTCSPrevClose float,
SumOfTataOpen float,
SumOfTCSOpen float,
CompAsPrevMonTataOpen float,
CompASPrevMonTCSOpen float)

INSERT INTO  TATAMOTORS_TCSshares
	SELECT 
		a.Series, a.Symbol, b.Symbol as TCS_Symbol , YEAR(a.Date)  as Year, MONTH(a.Date) as Month,
			SUM(a.[Prev Close]) as SumOfTataPrevClose,
			SUM(b.[Prev Close]) as SumOfTCSPrevClose,
				LAG(SUM(a.[Prev Close])) over (Order by year(a.Date), month(a.Date)) as CompAsPrevMonTataPrevClose,   -- ## Compare as previous month of tatamotors of prev close
				--b.Symbol, YEAR(a.Date)  as Year, MONTH(a.Date) as Month,
				LAG(SUM(b.[Prev close])) over (Order by year(b.Date), month(b.Date)) as CompAsPrevMonTCSPrevClose,  -- ## Compare as previous month of tcs of prev close
			SUM(a.[Open]) as SumOfTataOpen,
			SUM(b.[Open]) as SumOfTCSOpen,
				LAG(SUM(a.[Open])) over (Order by year(a.Date), month(a.Date)) as CompAsPrevMonTataOpen,  -- ## Compare as previous month of tatamotors of OPen value
				LAG(SUM(b.[Open])) over (Order by year(b.Date), month(b.Date)) as CompASPrevMonTCSOpen  -- ## Compare as previous month of tcs of open values
			FROM salesreport..TATAMOTORS a
				JOIN salesreport..TCS b
					ON  a.Series = b.Series
					Where Year(b.Date) in (2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021) 
				 and a.Symbol = 'TATAMOTORS'
			GROUP BY a. Series, a.Symbol, YEAR(a.Date), MONTH(a.Date), b.Symbol ,YEAR(b.Date), MONTH(b.Date)


SELECT * FROM TATAMOTORS_TCSshares
 
-- Q 6) Find max values of prev close of tatamotors and tcs in specific year

select 
	MAX(SumOfTataPrevClose) as MaxOfTataPrevclose , MAX(SumOfTCSPrevClose) as MaxOfTCSPrevClose
		from TATAMOTORS_TCSshares
			where year in (2020, 2021)

-- Q 7) Find maximum no of volume and trades in tatamotors in specific year
SELECT 
	MAX(SumOfVolume) as MaxOfVolume , MAX(SumOfTrades) as MaxOfTrades
		FROM TempSalesFrom2011_2021
			 WHERE Year in (2020, 2021)






	   
	 