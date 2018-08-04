SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--EXEC [rpt].[SalesByTicketType] '2016 Football'
CREATE PROCEDURE [rpt].[SalesByTicketType_bkp] (@Season NVARCHAR(50))--, @SeasonCode NVARCHAR(10) = NULL, @PreviousSeasonCode NVARCHAR(10) = NULL)
AS
SET NOCOUNT ON

--DECLARE @Season NVARCHAR(50) = '2016 Football'

IF OBJECT_ID('tempdb..#Seasons') IS NOT NULL
	DROP TABLE #Seasons
CREATE TABLE #Seasons (
	 SeasonCode NVARCHAR(10)
	,DimSeasonId INT
	,SchoolYear NVARCHAR(10)
	,CY BIT
	,PYSeasonCode NVARCHAR(10)
	,PYSchoolYear NVARCHAR(10)
	,CYSeasonCode NVARCHAR(10)
	,CYSchoolYear NVARCHAR(10)
)
INSERT INTO #Seasons (
	 SeasonCode
	,DimSeasonId
	,SchoolYear
	,CY
	,PYSeasonCode
	,PYSchoolYear
	,CYSeasonCode
	,CYSchoolYear
)
SELECT 
	 ds.SeasonCode
	,ds.DimSeasonId
	,s.SchoolYear
	,1 AS CY
	,s.PYSeasonCode
	,s.PrevSchoolYear AS PYSchoolYear
	,s.SeasonCode AS CYSeasonCode
	,s.SchoolYear AS CYSchoolYear
FROM dbo.Season_SchoolYear s (NOLOCK)
INNER JOIN dbo.DimSeason ds (NOLOCK)
	ON  s.SeasonCode = ds.SeasonCode
INNER JOIN dbo.DimSeasonHeader dsh (NOLOCK)
	ON  ds.Config_DefaultDimSeasonHeaderId = dsh.DimSeasonHeaderId
WHERE dsh.SeasonName = @Season
--WHERE SchoolYear = @SchoolYear
	--AND s.SeasonCode = @Season
UNION
SELECT 
	 s.PYSeasonCode AS SeasonCode
	,ds.DimSeasonId
	,s.PrevSchoolYear AS SchoolYear
	,0 AS CY
	,s.PYSeasonCode
	,s.PrevSchoolYear AS PYSchoolYear
	,s.SeasonCode AS CYSeasonCode
	,s.SchoolYear AS CYSchoolYear
FROM dbo.Season_SchoolYear s (NOLOCK)
INNER JOIN dbo.DimSeason ds (NOLOCK)
	ON  s.PYSeasonCode = ds.SeasonCode
INNER JOIN dbo.DimSeasonHeader dsh (NOLOCK)
	ON  ds.Config_DefaultDimSeasonHeaderId = dsh.DimSeasonHeaderId
INNER JOIN dbo.DimSeasonHeader p_dsh (NOLOCK)
	ON  dsh.DimSeasonHeaderId = p_dsh.PrevSeasonHeaderId
WHERE p_dsh.SeasonName = @Season;






--WITH CTE_Data
--AS (
SELECT
	 ISNULL(TicketTypeName, 'Total:') AS TicketTypeName
	,ISNULL(SeasonCode, '') AS SeasonCode
	,ISNULL(CY, '') AS CY
	,COALESCE(planscy.Tickets, CYTickets) CYTickets
	,CYRevenue
	,ISNULL(PY, '') AS PY
	,COALESCE(planspy.Tickets,PYTickets) PYTickets
	,PYRevenue
-- Select a.*, plans.*
FROM (
		SELECT GROUPING_ID(
					CASE WHEN tt.TicketTypeName = 'Unknown' THEN 'Misc'
						ELSE tt.TicketTypeName
						END
					,s.CYSeasonCode
					,s.PYSeasonCode
				) AS Group_ID
			,CASE WHEN tt.TicketTypeName = 'Unknown' THEN 'Misc'
				ELSE tt.TicketTypeName
				END AS TicketTypeName
			,s.CYSeasonCode AS SeasonCode
			,s.CYSeasonCode AS CY
			,SUM(ISNULL(CASE WHEN s.CY = 1 THEN fts.QtySeat END, 0)) AS CYTickets
			,SUM(ISNULL(CASE WHEN s.CY = 1 THEN fts.TotalRevenue END, 0)) AS CYRevenue
			,s.PYSeasonCode AS PY
			,SUM(ISNULL(CASE WHEN s.CY = 0 THEN fts.QtySeat END, 0)) AS PYTickets
			,SUM(ISNULL(CASE WHEN s.CY = 0 THEN fts.TotalRevenue END, 0)) AS PYRevenue
		--INTO #tmp
		FROM dbo.FactTicketSales fts (NOLOCK)
		INNER JOIN #Seasons s 
			ON  fts.DimSeasonId = s.DimSeasonId
		INNER JOIN dbo.DimTicketType tt (NOLOCK) 
			ON  fts.DimTicketTypeID = tt.DimTicketTypeID
		GROUP BY
				CASE WHEN tt.TicketTypeName = 'Unknown' THEN 'Misc'
				ELSE tt.TicketTypeName
				END
			,s.CYSeasonCode
			,s.PYSeasonCode
		WITH ROLLUP
) A
LEFT JOIN rpt.vw_SeasonTicketPlansSoldBySeason planscy
	ON a.SeasonCode = planscy.PlanCode AND a.TicketTypeName = 'Full Season'
LEFT JOIN rpt.vw_SeasonTicketPlansSoldBySeason planspy
	ON a.py = planspy.PlanCode AND a.TicketTypeName = 'Full Season'
WHERE (Group_ID = 1 OR Group_ID > 3)
ORDER BY TicketTypeName
--	)
--SELECT 
--	TicketTypeName,
--	SeasonCode,
--	'Tickets' AS QtyType,
--	CY,
--	CYTickets AS CYQty,
--	PY,
--	PYTickets AS PYQty
--FROM CTE_Data
--UNION
--SELECT 
--	TicketTypeName,
--	SeasonCode,
--	'Revenue' AS QtyType,
--	CY,
--	CYRevenue AS CYQty,
--	PY,
--	PYRevenue AS PYQty
--FROM CTE_Data
--ORDER BY
--	SeasonCode,
--	TicketTypeName

--DECLARE @Season NVARCHAR(10) = 'FB16'
--DECLARE @PYSeason NVARCHAR(10)
--DECLARE @SQL1 NVARCHAR(MAX)

----SET @Season = 'FB16'
--SET @PYSeason = (SELECT DISTINCT PYSeasonCode FROM dbo.Season_SchoolYear WHERE SeasonCode = @Season)


--SELECT CASE WHEN tt.TicketTypeName = 'Unknown' THEN 'Misc'
--		ELSE tt.TicketTypeName
--		END AS TicketTypeName
--	, SUM(fts.QtySeat) AS CYTickets
--INTO #tmpa
--FROM dbo.FactTicketSales fts
--JOIN dbo.DimSeason ds ON fts.DimSeasonId = ds.DimSeasonId
--JOIN dbo.Season_SchoolYear sy ON ds.SeasonCode = sy.SeasonCode
--JOIN dbo.DimTicketType tt ON fts.DimTicketTypeID = tt.DimTicketTypeID
--WHERE sy.SeasonCode = 'FB16'
--GROUP BY tt.TicketTypeName



--SELECT CASE WHEN tt.TicketTypeName = 'Unknown' THEN 'Misc'
--		ELSE tt.TicketTypeName
--		END AS TicketTypeName
--	, SUM(fts.QtySeat) AS PYTickets
--INTO #tmpb
--FROM dbo.FactTicketSales fts
--JOIN dbo.DimSeason ds ON fts.DimSeasonId = ds.DimSeasonId
--JOIN dbo.Season_SchoolYear sy ON ds.SeasonCode = sy.SeasonCode
--JOIN dbo.DimTicketType tt ON fts.DimTicketTypeID = tt.DimTicketTypeID
--WHERE sy.SeasonCode = 'FB15'--@PYSeason
--GROUP BY tt.TicketTypeName



--SET @SQL1 = 
--'DECLARE @SchoolYear NVARCHAR(10)
--SET @SchoolYear = ''16-17''
--SELECT COALESCE(a.TicketTypeName,b.TicketTypeName) TicketTypeName, a.CYTickets AS ''' + @Season + '''
--	, b.PYTickets AS ''' + @PYSeason + '''
--FROM #tmpa a
--FULL OUTER JOIN #tmpb b on a.TicketTypeName = b.TicketTypeName
--ORDER BY COALESCE(a.TicketTypeName,b.TicketTypeName)'



--EXECUTE sp_executesql @SQL1
GO
