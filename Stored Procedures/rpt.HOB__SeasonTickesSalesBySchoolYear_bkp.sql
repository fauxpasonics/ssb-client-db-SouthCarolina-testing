SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--EXEC [rpt].[HOB__SeasonTickesSalesBySchoolYear] '16-17'
Create PROCEDURE [rpt].[HOB__SeasonTickesSalesBySchoolYear_bkp] (@SchoolYear NVARCHAR(10))
AS

--DECLARE @SchoolYear NVARCHAR(10) = '16-17'
DECLARE @PYSchoolYear NVARCHAR(10)

SET @PYSchoolYear = (SELECT DISTINCT PrevSchoolYear FROM dbo.Season_SchoolYear WHERE SchoolYear = @SchoolYear)

SELECT
	A.Sport,
	A.AccountID,
	@SchoolYear AS CY,
	@PYSchoolYear AS PY,
	SUM(CASE WHEN A.[Year] = 'CY' THEN A.Revenue END) AS CY_Revenue,
	SUM(CASE WHEN A.[Year] = 'PY' THEN A.Revenue END) AS PY_Revenue,
	SUM(CASE WHEN A.[Year] = 'CY' THEN A.Tickets END) AS CY_CntTickets,
	SUM(CASE WHEN A.[Year] = 'PY' THEN A.Tickets END) AS PY_CntTickets,
	/*CASE WHEN SUM(CAST(CASE WHEN A.[Year] = 'CY' THEN A.Tickets END AS DECIMAL(15,2))) <> 0 
		THEN CAST(SUM(CASE WHEN A.Category = 'New' AND A.[Year] = 'CY' THEN A.Tickets END) / SUM(CAST(CASE WHEN A.[Year] = 'CY' THEN A.Tickets END AS DECIMAL(15,6))) AS DECIMAL(15,5))
		END AS CY_PctNew,
	CASE WHEN SUM(CAST(CASE WHEN A.[Year] = 'PY' THEN A.Tickets END AS DECIMAL(15,2))) <> 0 
		THEN CAST(SUM(CASE WHEN A.Category = 'New' AND A.[Year] = 'PY' THEN A.Tickets END) / SUM(CAST(CASE WHEN A.[Year] = 'PY' THEN A.Tickets END AS DECIMAL(15,6))) AS DECIMAL(15,5)) 
		END AS PY_PctNew,*/
	/*CASE WHEN SUM(CAST(CASE WHEN A.[Year] = 'CY' THEN A.Tickets END AS DECIMAL(15,2))) <> 0 
		THEN CAST(SUM(CASE WHEN A.Category = 'Renew' AND A.[Year] = 'CY' THEN A.Tickets END) / SUM(CAST(CASE WHEN A.[Year] = 'CY' THEN A.Tickets END AS DECIMAL(15,6))) AS DECIMAL(15,5)) 
		END AS CY_PctRenew,*/
	CASE WHEN SUM(CAST(CASE WHEN A.[Year] = 'PY' THEN A.Tickets END AS DECIMAL(15,2))) <> 0 
		THEN CAST(SUM(CASE WHEN A.Category = 'Renew' AND A.[Year] = 'PY' THEN A.Tickets END) / SUM(CAST(CASE WHEN A.[Year] = 'PY' THEN A.Tickets END AS DECIMAL(15,6))) AS DECIMAL(15,5))
		END AS PY_PctRenew,
	ISNULL((CASE WHEN SUM(CAST(CASE WHEN A.[Year] = 'CY' THEN A.Tickets END AS DECIMAL(15,2))) <> 0 
		THEN SUM(CASE WHEN A.Category = 'New' AND A.[Year] = 'CY' THEN A.Tickets END)
		END), 0) AS CY_CntNew,
	ISNULL((CASE WHEN SUM(CAST(CASE WHEN A.[Year] = 'PY' THEN A.Tickets END AS DECIMAL(15,2))) <> 0 
		THEN SUM(CASE WHEN A.Category = 'New' AND A.[Year] = 'PY' THEN A.Tickets END)
		END), 0) AS PY_CntNew
INTO #tmp1
FROM (
		SELECT LEFT(ds.SeasonCode,2) AS Sport,
			fts.SSID_acct_id AccountID,
			SUM(fts.QtySeat) AS Tickets, 
			SUM(fts.TotalRevenue) AS Revenue,
			CASE WHEN sy.SchoolYear = @SchoolYear THEN 'CY' ELSE 'PY' END AS [Year],
			CASE 
				WHEN fts.DimPlanTypeId = 1 THEN 'New' 
				WHEN fts.DimPlanTypeId = 2 THEN 'Renew' 
				ELSE 'Others'
				END AS Category
		FROM dbo.FactTicketSales fts (NOLOCK)
		INNER JOIN dbo.DimSeason ds  (NOLOCK)
			ON  fts.DimSeasonId = ds.DimSeasonId
		INNER JOIN dbo.Season_SchoolYear sy (NOLOCK)
			ON  ds.SeasonCode = sy.SeasonCode
		WHERE sy.SchoolYear IN (@SchoolYear, @PYSchoolYear)
			AND fts.DimTicketTypeId = 1
		GROUP BY 
			LEFT(ds.SeasonCode,2),
			fts.SSID_acct_id, 
			sy.SchoolYear,
			CASE 
				WHEN fts.DimPlanTypeId = 1 THEN 'New' 
				WHEN fts.DimPlanTypeId = 2 THEN 'Renew' 
				ELSE 'Others'
				END
	) A
GROUP BY
	A.Sport, A.AccountID
ORDER BY 
	A.Sport, A.AccountID


SELECT Sport
	, CY
	, PY
	, SUM(CY_Revenue) CY_Revenue
	, SUM(PY_Revenue) PY_Revenue
	, SUM(CY_CntTickets) CY_CntTickets
	, SUM(PY_CntTickets) PY_CntTickets
	, SUM(CASE WHEN CY_CntTickets >= PY_CntTickets THEN PY_CntTickets
		ELSE CY_CntTickets END) AS CY_CntRenewTickets
	--, PY_PctRenew
	, SUM(CY_CntNew) CY_CntNew
	, SUM(PY_CntNew) PY_CntNew
INTO #tmp2
FROM #tmp1
GROUP BY Sport, CY, PY


SELECT CASE WHEN t.sport = 'BB' THEN 'MBB'
			ELSE t.Sport END AS Sport
	, t.CY
	, t.PY
	, planscy.Tickets AS CY_Tickets
	, planspy.Tickets AS PY_Tickets
	, t.CY_Revenue
	, t.PY_Revenue
	, t.CY_CntNew
	, t.PY_CntNew
	, CAST(t.CY_CntRenewTickets AS DECIMAL(15,2))/CAST(t.PY_CntTickets AS DECIMAL(15,2)) AS CY_PctRenew
	, 0 AS PY_PctRenew
FROM #tmp2 t
JOIN rpt.vw_SeasonTicketPlansSoldBySeason planscy
	ON t.CY = planscy.SchoolYear
	AND t.Sport = LEFT(planscy.PlanCode,2)
JOIN rpt.vw_SeasonTicketPlansSoldBySeason planspy
	ON t.PY = planspy.SchoolYear
	AND t.Sport = LEFT(planspy.PlanCode,2)
--GROUP BY t.sport, t.CY, t.PY, planscy.Tickets, planspy.Tickets, t.CY_Revenue, t.PY_Revenue
--	, t.CY_CntNew, t.PY_CntNew, t.CY_CntTickets, t.PY_CntTickets--, t.PY_PctRenew
ORDER BY CASE WHEN t.sport = 'BB' THEN 'MBB'
			ELSE t.Sport END





/*SELECT
	A.Sport,
	@SchoolYear AS CY,
	@PYSchoolYear AS PY,
	SUM(CASE WHEN A.[Year] = 'CY' THEN A.Revenue END) AS CY_Revenue,
	SUM(CASE WHEN A.[Year] = 'PY' THEN A.Revenue END) AS PY_Revenue,
	SUM(CASE WHEN A.[Year] = 'CY' THEN A.Tickets END) AS CY_CntTickets,
	SUM(CASE WHEN A.[Year] = 'PY' THEN A.Tickets END) AS PY_CntTickets,
	CASE WHEN SUM(CAST(CASE WHEN A.[Year] = 'CY' THEN A.Tickets END AS DECIMAL(15,2))) <> 0 
		THEN CAST(SUM(CASE WHEN A.Category = 'New' AND A.[Year] = 'CY' THEN A.Tickets END) / SUM(CAST(CASE WHEN A.[Year] = 'CY' THEN A.Tickets END AS DECIMAL(15,6))) AS DECIMAL(15,5))
		END AS CY_PctNew,
	CASE WHEN SUM(CAST(CASE WHEN A.[Year] = 'PY' THEN A.Tickets END AS DECIMAL(15,2))) <> 0 
		THEN CAST(SUM(CASE WHEN A.Category = 'New' AND A.[Year] = 'PY' THEN A.Tickets END) / SUM(CAST(CASE WHEN A.[Year] = 'PY' THEN A.Tickets END AS DECIMAL(15,6))) AS DECIMAL(15,5)) 
		END AS PY_PctNew,
	/*CASE WHEN SUM(CAST(CASE WHEN A.[Year] = 'CY' THEN A.Tickets END AS DECIMAL(15,2))) <> 0 
		THEN CAST(SUM(CASE WHEN A.Category = 'Renew' AND A.[Year] = 'CY' THEN A.Tickets END) / SUM(CAST(CASE WHEN A.[Year] = 'CY' THEN A.Tickets END AS DECIMAL(15,6))) AS DECIMAL(15,5)) 
		END AS CY_PctRenew,*/
	CASE WHEN 
	CASE WHEN SUM(CAST(CASE WHEN A.[Year] = 'PY' THEN A.Tickets END AS DECIMAL(15,2))) <> 0 
		THEN CAST(SUM(CASE WHEN A.Category = 'Renew' AND A.[Year] = 'PY' THEN A.Tickets END) / SUM(CAST(CASE WHEN A.[Year] = 'PY' THEN A.Tickets END AS DECIMAL(15,6))) AS DECIMAL(15,5))
		END AS PY_PctRenew,
	ISNULL((CASE WHEN SUM(CAST(CASE WHEN A.[Year] = 'CY' THEN A.Tickets END AS DECIMAL(15,2))) <> 0 
		THEN SUM(CASE WHEN A.Category = 'New' AND A.[Year] = 'CY' THEN A.Tickets END)
		END), 0) AS CY_CntNew,
	ISNULL((CASE WHEN SUM(CAST(CASE WHEN A.[Year] = 'PY' THEN A.Tickets END AS DECIMAL(15,2))) <> 0 
		THEN SUM(CASE WHEN A.Category = 'New' AND A.[Year] = 'PY' THEN A.Tickets END)
		END), 0) AS PY_CntNew
INTO #tmp
FROM (
		SELECT LEFT(ds.SeasonCode,2) AS Sport,
			SUM(fts.QtySeat) AS Tickets, 
			SUM(fts.TotalRevenue) AS Revenue,
			CASE WHEN sy.SchoolYear = @SchoolYear THEN 'CY' ELSE 'PY' END AS [Year],
			CASE 
				WHEN fts.DimPlanTypeId = 1 THEN 'New' 
				WHEN fts.DimPlanTypeId = 2 THEN 'Renew' 
				ELSE 'Others'
				END AS Category
		FROM dbo.FactTicketSales fts (NOLOCK)
		INNER JOIN dbo.DimSeason ds  (NOLOCK)
			ON  fts.DimSeasonId = ds.DimSeasonId
		INNER JOIN dbo.Season_SchoolYear sy (NOLOCK)
			ON  ds.SeasonCode = sy.SeasonCode
		WHERE sy.SchoolYear IN (@SchoolYear, @PYSchoolYear)
			AND fts.DimTicketTypeId = 1
		GROUP BY 
			LEFT(ds.SeasonCode,2), 
			sy.SchoolYear,
			CASE 
				WHEN fts.DimPlanTypeId = 1 THEN 'New' 
				WHEN fts.DimPlanTypeId = 2 THEN 'Renew' 
				ELSE 'Others'
				END
	) A
GROUP BY
	Sport
ORDER BY 
	Sport



SELECT CASE WHEN t.sport = 'BB' THEN 'MBB'
			ELSE t.Sport END AS Sport
	, t.CY
	, t.PY
	, planscy.Tickets AS CY_Tickets
	, planspy.Tickets AS PY_Tickets
	, t.CY_Revenue
	, t.PY_Revenue
	, t.CY_PctNew
	, t.PY_PctNew
	, t.CY_CntNew
	, t.PY_CntNew
	/*, CAST(((CASE WHEN t.CY_CntTickets>t.PY_CntTickets THEN CAST(t.PY_CntTickets AS DECIMAL(15,2))
		ELSE CAST(t.CY_CntTickets AS DECIMAL(15,2))
		END) / t.PY_CntTickets) AS DECIMAL(15,2)) AS CY_PctRenew*/
	, (CAST(SUM(CASE WHEN t.CY_CntTickets>=t.PY_CntTickets THEN CAST(t.PY_CntTickets AS DECIMAL(15,2))
		ELSE t.CY_CntTickets END) AS DECIMAL(15,2)))/CAST(t.PY_CntTickets AS DECIMAL(15,2)) AS CY_PctRenew
	, t.PY_PctRenew
FROM #tmp t
JOIN rpt.vw_SeasonTicketPlansSoldBySeason planscy
	ON t.CY = planscy.SchoolYear
	AND t.Sport = LEFT(planscy.PlanCode,2)
JOIN rpt.vw_SeasonTicketPlansSoldBySeason planspy
	ON t.PY = planspy.SchoolYear
	AND t.Sport = LEFT(planspy.PlanCode,2)
GROUP BY t.sport, t.CY, t.PY, planscy.Tickets, planspy.Tickets, t.CY_Revenue, t.PY_Revenue
	, t.CY_PctNew, t.PY_PctNew, t.CY_CntNew, t.PY_CntNew, t.CY_CntTickets, t.PY_CntTickets, t.PY_PctRenew
ORDER BY CASE WHEN t.sport = 'BB' THEN 'MBB'
			ELSE t.Sport END*/

GO
