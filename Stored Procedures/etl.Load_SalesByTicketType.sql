SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Load_SalesByTicketType]
AS

DECLARE @Season NVARCHAR(50)

TRUNCATE TABLE dbo.SalesByTicketType


SELECT *
INTO #WorkingSet
FROM rpt.vw_HOB_SeasonMenu

WHILE 1=1
BEGIN
	SELECT TOP 1 @Season = SeasonName
	FROM #WorkingSet

	IF @@ROWCOUNT = 0
		BREAK
	ELSE
		BEGIN

			WITH Seasons AS
			(
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
				WHERE p_dsh.SeasonName = @Season
			)

			INSERT INTO dbo.SalesByTicketType (Season, TicketTypeName, SeasonCode,
				CY, CYTickets, CYRevenue, PY, PYTickets, PYRevenue)

				SELECT
					@Season
					, ISNULL(TicketTypeName, 'Total:') AS TicketTypeName
					,ISNULL(SeasonCode, '') AS SeasonCode
					,ISNULL(CY, '') AS CY
					,COALESCE(planscy.Tickets, CYTickets) CYTickets
					,CYRevenue
					,ISNULL(PY, '') AS PY
					,COALESCE(planspy.Tickets,PYTickets) PYTickets
					,PYRevenue

				FROM (
						SELECT GROUPING_ID(
									CASE WHEN LEFT(p.PlanCode,5) IN ('FB15-', 'FB16-', 'FB17-', 'FB18-', 'FB19-', 'BB15-', 'BB16-', 'BB17-', 'BB18-', 'BB19-', 'BB20-')
										THEN 'Full Season' ELSE tt.TicketTypeName END
									,s.CYSeasonCode
									,s.PYSeasonCode
								) AS Group_ID
							,CASE WHEN LEFT(p.PlanCode,5) IN ('FB15-', 'FB16-', 'FB17-', 'FB18-', 'FB19-', 'BB15-', 'BB16-', 'BB17-', 'BB18-', 'BB19-', 'BB20-')
								THEN 'Full Season' ELSE tt.TicketTypeName END AS TicketTypeName
							,s.CYSeasonCode AS SeasonCode
							,s.CYSeasonCode AS CY
							,SUM(ISNULL(CASE WHEN s.CY = 1 THEN fts.QtySeat END, 0)) AS CYTickets
							,SUM(ISNULL(CASE WHEN s.CY = 1 THEN fts.TotalRevenue END, 0)) AS CYRevenue
							,s.PYSeasonCode AS PY
							,SUM(ISNULL(CASE WHEN s.CY = 0 THEN fts.QtySeat END, 0)) AS PYTickets
							,SUM(ISNULL(CASE WHEN s.CY = 0 THEN fts.TotalRevenue END, 0)) AS PYRevenue
						--INTO #tmp
						FROM dbo.FactTicketSales fts (NOLOCK)
						INNER JOIN Seasons s 
							ON  fts.DimSeasonId = s.DimSeasonId
						INNER JOIN dbo.DimTicketType tt (NOLOCK) 
							ON  fts.DimTicketTypeID = tt.DimTicketTypeID
						INNER JOIN dbo.DimPlan p (NOLOCK)
							ON fts.DimPlanId = p.DimPlanId
						GROUP BY (CASE WHEN LEFT(p.PlanCode,5) IN ('FB15-', 'FB16-', 'FB17-', 'FB18-', 'FB19-', 'BB15-', 'BB16-', 'BB17-', 'BB18-', 'BB19-', 'BB20-')
								THEN 'Full Season' ELSE tt.TicketTypeName END)
							,s.CYSeasonCode
							,s.PYSeasonCode
						WITH ROLLUP
				) A
				LEFT JOIN (
						SELECT LEFT(PlanCode, 4) PlanCode, SchoolYear, PrevSchoolYear, SUM(Tickets) Tickets
						FROM rpt.vw_SeasonTicketPlansSoldBySeason
						GROUP BY LEFT(PlanCode, 4), SchoolYear, PrevSchoolYear
					) planscy ON a.SeasonCode = PlanCode AND a.TicketTypeName = 'Full Season'
				LEFT JOIN (
						SELECT LEFT(PlanCode, 4) PlanCode, SchoolYear, PrevSchoolYear, SUM(Tickets) Tickets
						FROM rpt.vw_SeasonTicketPlansSoldBySeason
						GROUP BY LEFT(PlanCode, 4), SchoolYear, PrevSchoolYear
					) planspy ON a.py = LEFT(planspy.PlanCode,4) AND a.TicketTypeName = 'Full Season'
				WHERE (Group_ID = 0 OR Group_ID > 3) AND ISNULL(TicketTypeName, 'Total:') <> 'Unknown'
				ORDER BY TicketTypeName
			;

			DELETE
			FROM #WorkingSet
			WHERE SeasonName = @Season
			;

		END
		;

	CONTINUE
	;

END
;





GO
