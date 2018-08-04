SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [rpt].[HOB__TickesSalesBySchoolYear_bkp]  (@SchoolYear NVARCHAR(10))
AS

--drop table #tmpa
--drop table #tmpb
--DECLARE @SchoolYear NVARCHAR(10)='16-17'
DECLARE @PYSchoolYear NVARCHAR(10)
DECLARE @SQL1 NVARCHAR(MAX)


SET @PYSchoolYear = (SELECT DISTINCT PrevSchoolYear FROM dbo.Season_SchoolYear WHERE SchoolYear = @SchoolYear)

SELECT 
	CASE WHEN COALESCE(a.Sport, b.Sport) = 'BB' THEN 'MBB'
		ELSE COALESCE(a.Sport, b.Sport)
		END AS Sport
	, a.CYSeatDonationQty AS CYSeatDonationQty
	, a.CYSeatDonationRevenue AS CYSeatDonationRevenue
	, a.CYTickets AS CYTickets
	, a.CYRevenue AS CYRevenue
	, b.PYSeatDonationQty AS PYSeatDonationQty
	, b.PYSeatDonationRevenue AS PYSeatDonationsRevenue
	, b.PYTickets AS PYTickets
	, b.PYRevenue AS PYRevenue
	, @SchoolYear CY
	, @PYSchoolYear PY
FROM 
(
	SELECT LEFT(ds.SeasonCode,2) Sport
		, SUM(CASE WHEN fts.DimTicketTypeID = 12 THEN fts.QtySeat END) CYSeatDonationQty
		, SUM(CASE WHEN fts.DimTicketTypeID = 12 THEN fts.TotalRevenue END) CYSeatDonationRevenue
		, SUM(fts.QtySeat) AS CYTickets
		, SUM(fts.TotalRevenue) AS CYRevenue
	FROM dbo.FactTicketSales fts
	JOIN dbo.DimSeason ds ON fts.DimSeasonId = ds.DimSeasonId
	JOIN dbo.Season_SchoolYear sy ON ds.SeasonCode = sy.SeasonCode
	LEFT JOIN dbo.SeatDonations sd ON fts.DimPriceCodeId = sd.DimPriceCodeID
	WHERE sy.SchoolYear = @SchoolYear
	GROUP BY LEFT(ds.SeasonCode,2)	
) a
FULL OUTER JOIN 
(
	SELECT LEFT(sy.PYSeasonCode,2) Sport
		, SUM(CASE WHEN fts.DimTicketTypeID = 12 THEN fts.QtySeat END) PYSeatDonationQty
		, SUM(CASE WHEN fts.DimTicketTypeID = 12 THEN fts.TotalRevenue END) PYSeatDonationRevenue
		, SUM(fts.QtySeat) AS PYTickets
		, SUM(fts.TotalRevenue) AS PYRevenue
	FROM dbo.FactTicketSales fts
	JOIN dbo.DimSeason ds ON fts.DimSeasonId = ds.DimSeasonId
	JOIN dbo.Season_SchoolYear sy ON ds.SeasonCode = sy.PYSeasonCode
	LEFT JOIN dbo.SeatDonations sd ON fts.DimPriceCodeId = sd.DimPriceCodeID
	WHERE sy.SchoolYear = @SchoolYear
	GROUP BY LEFT(sy.PYSeasonCode,2)
--ORDER BY LEFT(sy.PYSeasonCode,2)
) b 
	on a.Sport = b.Sport

UNION ALL

SELECT 'GC' AS Sport
	, NULL AS CYSeatDonationsQty
	, NULL AS CYSeatDonationRevenue
	, SUM(CASE WHEN RIGHT(fund_name,2) = RIGHT(@SchoolYear,2) THEN 1 END) AS CYTickets
	, SUM(CASE WHEN RIGHT(fund_name,2) = RIGHT(@SchoolYear,2) THEN donation_paid_amount END) AS CYRevenue
	, NULL AS PYSeatDonationsQty
	, NULL AS PYSeatDonationsRevenue
	, SUM(CASE WHEN RIGHT(fund_name,2) = RIGHT(@PYSchoolYear,2) THEN 1 END) AS PYTickets
	, SUM(CASE WHEN RIGHT(fund_name,2) = RIGHT(@PYSchoolYear,2) THEN donation_paid_amount END) AS PYRevenue
	, @SchoolYear
	, @PYSchoolYear
FROM ods.TM_Donation
WHERE fund_name LIKE 'GC%' OR fund_name LIKE 'LFPY%'
ORDER BY CASE WHEN COALESCE(a.Sport, b.Sport) = 'BB' THEN 'MBB'
		ELSE COALESCE(a.Sport, b.Sport)
		END




/*---- OLD CODE ----
SELECT LEFT(ds.SeasonCode,2) Sport, SUM(fts.QtySeat) AS CYTickets, SUM(fts.TotalRevenue) AS CYRevenue
INTO #tmpa
FROM dbo.FactTicketSales fts
JOIN dbo.DimSeason ds ON fts.DimSeasonId = ds.DimSeasonId
JOIN dbo.Season_SchoolYear sy ON ds.SeasonCode = sy.SeasonCode
WHERE sy.SchoolYear = @SchoolYear
GROUP BY LEFT(ds.SeasonCode,2)
--ORDER BY LEFT(ds.SeasonCode,2)


SELECT LEFT(sy.PYSeasonCode,2) Sport
	, SUM(fts.QtySeat) AS PYTickets, SUM(fts.TotalRevenue) AS PYRevenue
INTO #tmpb
FROM dbo.FactTicketSales fts
JOIN dbo.DimSeason ds ON fts.DimSeasonId = ds.DimSeasonId
JOIN dbo.Season_SchoolYear sy ON ds.SeasonCode = sy.PYSeasonCode
WHERE sy.SchoolYear = @SchoolYear
GROUP BY LEFT(sy.PYSeasonCode,2)
--ORDER BY LEFT(sy.PYSeasonCode,2)

--SET @SQL1 = 
--DECLARE @SchoolYear NVARCHAR(10)
--SET @SchoolYear = ''16-17''
SELECT 
	CASE WHEN COALESCE(a.Sport, b.Sport) = 'BB' THEN 'MBB'
		ELSE COALESCE(a.Sport, b.Sport)
		END AS Sport
	, a.CYTickets AS CYTickets, 
	a.CYRevenue AS CYRevenue,
	b.PYTickets AS PYTickets,
	b.PYRevenue AS PYRevenue,
	@SchoolYear CY,
	@PYSchoolYear PY
FROM #tmpa a
FULL OUTER JOIN #tmpb b 
	on a.Sport = b.Sport
ORDER BY CASE WHEN COALESCE(a.Sport, b.Sport) = 'BB' THEN 'MBB'
		ELSE COALESCE(a.Sport, b.Sport)
		END
*/

/*SET @SQL1 = 
'DECLARE @SchoolYear NVARCHAR(10)
SET @SchoolYear = ''16-17''
SELECT COALESCE(a.Sport,b.Sport) Sport, a.CYTickets AS ''' + @SchoolYear + ' Tickets' + ''', a.CYRevenue AS ''' + @SchoolYear + ' Revenue' + '''
	, b.PYTickets AS ''' + @PYSchoolYear + ' Tickets' + ''', b.PYRevenue AS ''' + @PYSchoolYear + ' Revenue' + '''
FROM #tmpa a
FULL OUTER JOIN #tmpb b on a.Sport = b.Sport
ORDER BY COALESCE(a.Sport,b.Sport)'*/












GO
