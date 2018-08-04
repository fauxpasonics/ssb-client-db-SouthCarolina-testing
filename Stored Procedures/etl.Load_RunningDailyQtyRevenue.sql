SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Load_RunningDailyQtyRevenue]
AS

DECLARE @Season NVARCHAR(150)

TRUNCATE TABLE dbo.RunningDailyQtyRevenue


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
				SELECT dsh.DimSeasonHeaderId
					,ds.SeasonCode
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
			)
			, TicketSales AS 
			(
				SELECT
					 dd.CalDate SaleDate
					,tt.TicketTypeName
					,DATEDIFF(DAY, r.RenewalDeadline, dd.CalDate) DaysOfRenewalCycle
					,SUM(f.TotalRevenue) AS DailyRevenue
					,SUM(f.QtySeat) AS DailyQty
				FROM dbo.FactTicketSales f (NOLOCK)
				JOIN Seasons cte1
					ON f.DimSeasonId = cte1.DimSeasonId
				JOIN dbo.DimDate dd (NOLOCK)
					ON f.DimDateId = dd.DimDateId
				JOIN dbo.DimTicketType tt (NOLOCK)
					ON f.DimTicketTypeId = tt.DimTicketTypeId
				JOIN rpt.SeasonRenewalDeadlines r (NOLOCK)
					ON r.DimSeasonHeaderID = cte1.DimSeasonHeaderId
				WHERE tt.TicketTypeName NOT IN ('Unknown','Seat Donation', 'Seat Premium', 'Parking', 'TShirt Package')
					--AND sh.SeasonName = @Season
					--AND pc.PriceCode <> 'AVIS'
					--AND i.ItemCode NOT LIKE '%CHAR'
					--AND ((f.PaidAmount > 0 AND f.TotalRevenue > 0) OR (f.PaidAmount = 0 AND f.TotalRevenue = 0))
				GROUP BY tt.TicketTypeName, dd.CalDate, DATEDIFF(DAY, r.RenewalDeadline, dd.CalDate)
			)

			INSERT INTO dbo.RunningDailyQtyRevenue (Season, TicketTypeName, SaleDate, DaysOfRenewalCycle,
				DailyRevenue, RunningSales, DailyQty, RunningQty)
			
				SELECT
					@Season
					,CASE WHEN dr.TicketTypeName = 'Mobile Season Ticket' THEN 'Mini Plan' ELSE dr.TicketTypeName END AS TicketTypeName
					,dr.SaleDate
					,dr.DaysOfRenewalCycle
					,dr.DailyRevenue
					,rt.RunningSales
					,dr.DailyQty
					,rt.RunningQty
				FROM TicketSales dr
				INNER JOIN (
						SELECT
							 TicketTypeName
							,SaleDate
							,SUM(DailyRevenue) OVER (PARTITION BY TicketTypeName ORDER BY SaleDate ROWS UNBOUNDED PRECEDING) AS RunningSales
							,SUM(DailyQty) OVER (PARTITION BY TicketTypeName ORDER BY SaleDate ROWS UNBOUNDED PRECEDING) AS RunningQty
						FROM TicketSales
					) rt 
					ON  dr.SaleDate = rt.SaleDate 
					AND rt.TicketTypeName = dr.TicketTypeName
				ORDER BY dr.TicketTypeName, dr.SaleDate
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
