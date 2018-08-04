SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Load_HOB_SeasonTicketSalesBySchoolYear]
AS

DECLARE @SchoolYear NVARCHAR(10)
DECLARE @PYSchoolYear NVARCHAR(10)

TRUNCATE TABLE dbo.HOB_SeasonTicketSalesBySchoolYear


SELECT *
INTO #workingSet
FROM rpt.vw_SchoolYear


WHILE 1=1
BEGIN
	SELECT TOP 1 @SchoolYear = SchoolYear
	FROM #workingSet

	IF @@ROWCOUNT = 0
		BREAK
	ELSE
		BEGIN
--DECLARE @SchoolYear NVARCHAR(10) = '16-17' DECLARE @PYSchoolYear NVARCHAR(10)


			SET @PYSchoolYear = (SELECT DISTINCT PrevSchoolYear FROM dbo.Season_SchoolYear WHERE SchoolYear = @SchoolYear)
			;

			WITH FirstStep AS
			(
				SELECT
					A.Sport,
					A.AccountID,
					@SchoolYear AS CY,
					@PYSchoolYear AS PY,
					SUM(CASE WHEN A.[Year] = 'CY' THEN A.Revenue END) AS CY_Revenue,
					SUM(CASE WHEN A.[Year] = 'PY' THEN A.Revenue END) AS PY_Revenue,
					SUM(CASE WHEN A.[Year] = 'CY' THEN A.Tickets END) AS CY_CntTickets,
					SUM(CASE WHEN A.[Year] = 'PY' THEN A.Tickets END) AS PY_CntTickets
					/*CASE WHEN SUM(CAST(CASE WHEN A.[Year] = 'CY' THEN A.Tickets END AS DECIMAL(15,2))) <> 0 
						THEN CAST(SUM(CASE WHEN A.Category = 'New' AND A.[Year] = 'CY' THEN A.Tickets END) / SUM(CAST(CASE WHEN A.[Year] = 'CY' THEN A.Tickets END AS DECIMAL(15,6))) AS DECIMAL(15,5))
						END AS CY_PctNew,
					CASE WHEN SUM(CAST(CASE WHEN A.[Year] = 'PY' THEN A.Tickets END AS DECIMAL(15,2))) <> 0 
						THEN CAST(SUM(CASE WHEN A.Category = 'New' AND A.[Year] = 'PY' THEN A.Tickets END) / SUM(CAST(CASE WHEN A.[Year] = 'PY' THEN A.Tickets END AS DECIMAL(15,6))) AS DECIMAL(15,5)) 
						END AS PY_PctNew,*/
					/*CASE WHEN SUM(CAST(CASE WHEN A.[Year] = 'CY' THEN A.Tickets END AS DECIMAL(15,2))) <> 0 
						THEN CAST(SUM(CASE WHEN A.Category = 'Renew' AND A.[Year] = 'CY' THEN A.Tickets END) / SUM(CAST(CASE WHEN A.[Year] = 'CY' THEN A.Tickets END AS DECIMAL(15,6))) AS DECIMAL(15,5)) 
						END AS CY_PctRenew,*/
					/*CASE WHEN SUM(CAST(CASE WHEN A.[Year] = 'PY' THEN A.Tickets END AS DECIMAL(15,2))) <> 0 
						THEN CAST(SUM(CASE WHEN A.Category = 'Renew' AND A.[Year] = 'PY' THEN A.Tickets END) / SUM(CAST(CASE WHEN A.[Year] = 'PY' THEN A.Tickets END AS DECIMAL(15,6))) AS DECIMAL(15,5))
						END AS PY_PctRenew,
					ISNULL((CASE WHEN SUM(CAST(CASE WHEN A.[Year] = 'CY' THEN A.Tickets END AS DECIMAL(15,2))) <> 0 
						THEN SUM(CASE WHEN A.Category = 'New' AND A.[Year] = 'CY' THEN A.Tickets END)
						END), 0) AS CY_CntNew,
					ISNULL((CASE WHEN SUM(CAST(CASE WHEN A.[Year] = 'PY' THEN A.Tickets END AS DECIMAL(15,2))) <> 0 
						THEN SUM(CASE WHEN A.Category = 'New' AND A.[Year] = 'PY' THEN A.Tickets END)
						END), 0) AS PY_CntNew*/
				FROM (
						SELECT LEFT(ds.SeasonCode,2) AS Sport,
							fts.SSID_acct_id AccountID,
							SUM(fts.QtySeat) AS Tickets, 
							SUM(fts.TotalRevenue) AS Revenue,
							CASE WHEN sy.SchoolYear = @SchoolYear THEN 'CY' ELSE 'PY' END AS [Year]
							/*CASE 
								WHEN fts.DimPlanTypeId = 1 THEN 'New' 
								WHEN fts.DimPlanTypeId = 2 THEN 'Renew' 
								ELSE 'Others'
								END AS Category*/
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
							sy.SchoolYear
							/*CASE 
								WHEN fts.DimPlanTypeId = 1 THEN 'New' 
								WHEN fts.DimPlanTypeId = 2 THEN 'Renew' 
								ELSE 'Others'
								END*/
					) A
				GROUP BY
					A.Sport, A.AccountID
			)

			, SecondStep AS
			(
				
				SELECT Sport
					, AccountID
					, CY
					, PY
					, CY_Revenue
					, PY_Revenue
					, CY_CntTickets
					, PY_CntTickets
					, CASE WHEN ISNULL(CY_CntTickets, 0) >= ISNULL(PY_CntTickets, 0) THEN PY_CntTickets
						WHEN ISNULL(CY_CntTickets, 0) < ISNULL(PY_CntTickets, 0) THEN CY_CntTickets
						END AS CY_CntRenewTickets
					, CASE WHEN ISNULL(CY_CntTickets, 0) > ISNULL(PY_CntTickets, 0) THEN (CY_CntTickets - PY_CntTickets)
						ELSE 0 END AS CY_CntNew
				FROM FirstStep
			)


			, FinalStep AS 
			(
				SELECT Sport
					, CY
					, PY
					, SUM(CY_Revenue) CY_Revenue
					, SUM(PY_Revenue) PY_Revenue
					, SUM(CY_CntTickets) CY_CntTickets
					, SUM(PY_CntTickets) PY_CntTickets
					, SUM(CY_CntRenewTickets) AS CY_CntRenewTickets
					--, PY_PctRenew
					, SUM(CY_CntNew) CY_CntNew
					--, SUM(PY_CntNew) PY_CntNew
				FROM SecondStep
				GROUP BY Sport, CY, PY
			)

			INSERT INTO dbo.HOB_SeasonTicketSalesBySchoolYear (SchoolYear, Sport, CY, PY
				, CY_Tickets, PY_Tickets, CY_Revenue, PY_Revenue, CY_CntNew--, PY_CntNew
				, CY_PctRenew, PY_PctRenew)
			
				SELECT @SchoolYear
					, CASE WHEN t.sport = 'BB' THEN 'MBB'
							ELSE t.Sport END AS Sport
					, t.CY
					, t.PY
					, planscy.Tickets AS CY_Tickets
					, planspy.Tickets AS PY_Tickets
					, t.CY_Revenue
					, t.PY_Revenue
					, t.CY_CntNew
					--, t.PY_CntNew
					, CAST(t.CY_CntRenewTickets AS DECIMAL(15,2))/CAST(t.PY_CntTickets AS DECIMAL(15,2)) AS CY_PctRenew
					, 0 AS PY_PctRenew
				FROM FinalStep t
				JOIN (
						SELECT LEFT(PlanCode, 2) PlanCode, SchoolYear, PrevSchoolYear, SUM(Tickets) Tickets
						FROM rpt.vw_SeasonTicketPlansSoldBySeason
						GROUP BY LEFT(PlanCode, 2), SchoolYear, PrevSchoolYear
					) planscy ON t.CY = planscy.SchoolYear
					AND t.Sport = planscy.PlanCode
				JOIN (
						SELECT LEFT(PlanCode, 2) PlanCode, SchoolYear, PrevSchoolYear, SUM(Tickets) Tickets
						FROM rpt.vw_SeasonTicketPlansSoldBySeason
						GROUP BY LEFT(PlanCode, 2), SchoolYear, PrevSchoolYear
					)planspy ON t.PY = planspy.SchoolYear
					AND t.Sport = planspy.PlanCode
				--GROUP BY t.sport, t.CY, t.PY, planscy.Tickets, planspy.Tickets, t.CY_Revenue, t.PY_Revenue
				--	, t.CY_CntNew, t.PY_CntNew, t.CY_CntTickets, t.PY_CntTickets--, t.PY_PctRenew
				ORDER BY CASE WHEN t.sport = 'BB' THEN 'MBB'
							ELSE t.Sport END
				;

			DELETE
			FROM #workingSet
			WHERE SchoolYear = @SchoolYear
			;

		END
		;

	CONTINUE
	;

END
;

GO
