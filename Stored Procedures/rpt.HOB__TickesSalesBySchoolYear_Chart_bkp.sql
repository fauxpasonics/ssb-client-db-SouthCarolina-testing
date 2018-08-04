SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [rpt].[HOB__TickesSalesBySchoolYear_Chart_bkp]  (@SchoolYear NVARCHAR(10))
AS

--drop table #tmpa
--drop table #tmpb
--DECLARE @SchoolYear NVARCHAR(10)='16-17'
DECLARE @PYSchoolYear NVARCHAR(10)
DECLARE @SQL1 NVARCHAR(MAX)


SET @PYSchoolYear = (SELECT DISTINCT PrevSchoolYear FROM dbo.Season_SchoolYear WHERE SchoolYear = @SchoolYear)

SELECT 
	CASE WHEN a.Sport = 'BB' THEN 'MBB'
		ELSE a.Sport
		END AS Sport, 
	a.CYTickets AS Tickets, 
	a.CYRevenue AS Revenue,
	@SchoolYear Year
FROM 
(
	SELECT LEFT(ds.SeasonCode,2) Sport, SUM(fts.QtySeat) AS CYTickets, SUM(fts.TotalRevenue) AS CYRevenue
	FROM dbo.FactTicketSales fts
	JOIN dbo.DimSeason ds ON fts.DimSeasonId = ds.DimSeasonId
	JOIN dbo.Season_SchoolYear sy ON ds.SeasonCode = sy.SeasonCode
	WHERE sy.SchoolYear = @SchoolYear
	GROUP BY LEFT(ds.SeasonCode,2)
	--ORDER BY LEFT(ds.SeasonCode,2)
) a
UNION ALL
select 
	CASE WHEN b.Sport = 'BB' THEN 'MBB'
		ELSE b.Sport
		END Sport, 
	b.PYTickets AS Tickets,
	b.PYRevenue AS Revenue,
	@PYSchoolYear Year
FROM 
(
	SELECT LEFT(sy.PYSeasonCode,2) Sport, SUM(fts.QtySeat) AS PYTickets, SUM(fts.TotalRevenue) AS PYRevenue
	FROM dbo.FactTicketSales fts
	JOIN dbo.DimSeason ds ON fts.DimSeasonId = ds.DimSeasonId
	JOIN dbo.Season_SchoolYear sy ON ds.SeasonCode = sy.PYSeasonCode
	WHERE sy.SchoolYear = @SchoolYear
	GROUP BY LEFT(sy.PYSeasonCode,2)
	--ORDER BY LEFT(sy.PYSeasonCode,2)
) b 
UNION ALL

SELECT 'GC' AS Sport
	, SUM(CASE WHEN RIGHT(fund_name,2) = RIGHT(@SchoolYear,2) THEN 1 END) AS CYTickets
	, SUM(CASE WHEN RIGHT(fund_name,2) = RIGHT(@SchoolYear,2) THEN donation_paid_amount END) AS CYRevenue
	--, SUM(CASE WHEN RIGHT(fund_name,2) = RIGHT(@PYSchoolYear,2) THEN 1 END) AS PYTickets
	--, SUM(CASE WHEN RIGHT(fund_name,2) = RIGHT(@PYSchoolYear,2) THEN donation_paid_amount END) AS PYRevenue
	, @SchoolYear
	--, @PYSchoolYear
FROM ods.TM_Donation
WHERE fund_name LIKE 'GC%' OR fund_name LIKE 'LFPY%'

UNION ALL

SELECT 'GC' AS Sport
	--, SUM(CASE WHEN RIGHT(fund_name,2) = RIGHT(@SchoolYear,2) THEN 1 END) AS CYTickets
	--, SUM(CASE WHEN RIGHT(fund_name,2) = RIGHT(@SchoolYear,2) THEN donation_paid_amount END) AS CYRevenue
	, SUM(CASE WHEN RIGHT(fund_name,2) = RIGHT(@PYSchoolYear,2) THEN 1 END) AS PYTickets
	, SUM(CASE WHEN RIGHT(fund_name,2) = RIGHT(@PYSchoolYear,2) THEN donation_paid_amount END) AS PYRevenue
	--, @SchoolYear
	, @PYSchoolYear
FROM ods.TM_Donation
WHERE fund_name LIKE 'GC%' OR fund_name LIKE 'LFPY%'


/*
---- OLD CODE ----
SELECT LEFT(ds.SeasonCode,2) Sport, SUM(fts.QtySeat) AS CYTickets, SUM(fts.TotalRevenue) AS CYRevenue
INTO #tmpa
FROM dbo.FactTicketSales fts
JOIN dbo.DimSeason ds ON fts.DimSeasonId = ds.DimSeasonId
JOIN dbo.Season_SchoolYear sy ON ds.SeasonCode = sy.SeasonCode
WHERE sy.SchoolYear = @SchoolYear
GROUP BY LEFT(ds.SeasonCode,2)
--ORDER BY LEFT(ds.SeasonCode,2)


SELECT LEFT(sy.PYSeasonCode,2) Sport, SUM(fts.QtySeat) AS PYTickets, SUM(fts.TotalRevenue) AS PYRevenue
INTO #tmpb
FROM dbo.FactTicketSales fts
JOIN dbo.DimSeason ds ON fts.DimSeasonId = ds.DimSeasonId
JOIN dbo.Season_SchoolYear sy ON ds.SeasonCode = sy.PYSeasonCode
WHERE sy.SchoolYear = @SchoolYear
GROUP BY LEFT(sy.PYSeasonCode,2)
--ORDER BY LEFT(sy.PYSeasonCode,2)


/*SET @SQL1 = 
'DECLARE @SchoolYear NVARCHAR(10)
SET @SchoolYear = ''16-17''
SELECT COALESCE(a.Sport,b.Sport) Sport, a.CYTickets AS ''' + @SchoolYear + ' Tickets' + ''', a.CYRevenue AS ''' + @SchoolYear + ' Revenue' + '''
	, b.PYTickets AS ''' + @PYSchoolYear + ' Tickets' + ''', b.PYRevenue AS ''' + @PYSchoolYear + ' Revenue' + '''
FROM #tmpa a
FULL OUTER JOIN #tmpb b on a.Sport = b.Sport
ORDER BY COALESCE(a.Sport,b.Sport)'*/

--SET @SQL1 = 
--DECLARE @SchoolYear NVARCHAR(10)
--SET @SchoolYear = ''16-17''
SELECT 
	CASE WHEN a.Sport = 'BB' THEN 'MBB'
		ELSE a.Sport
		END AS Sport, 
	a.CYTickets AS Tickets, 
	a.CYRevenue AS Revenue,
	@SchoolYear Year
FROM #tmpa a
UNION ALL
select 
	CASE WHEN b.Sport = 'BB' THEN 'MBB'
		ELSE b.Sport
		END Sport, 
	b.PYTickets AS Tickets,
	b.PYRevenue AS Revenue,
	@PYSchoolYear Year
FROM #tmpb b 


*/









GO
