SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Load_RunningDailyQtyRevenue_OLD]
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

			WITH TicketSales AS 
			(
				SELECT
					 d.CalDate SaleDate
					,t.TicketTypeName
					,DATEDIFF(DAY, r.RenewalDeadline, d.CalDate) DaysOfRenewalCycle
					,SUM(f.TotalRevenue) AS DailyRevenue
					,SUM(f.QtySeat) AS DailyQty
				FROM dbo.FactTicketSales f
				INNER JOIN dbo.DimEvent e ON f.DimEventId = e.DimEventId
				INNER JOIN dbo.DimEventHeader eh ON e.DimEventHeaderId = eh.DimEventHeaderId
				INNER JOIN dbo.DimSeason s ON f.DimSeasonId = s.DimSeasonId
				INNER JOIN dbo.DimSeasonHeader sh ON s.Config_DefaultDimSeasonHeaderId = sh.DimSeasonHeaderId
				INNER JOIN dbo.DimDate d ON f.DimDateId = d.DimDateId
				INNER JOIN rpt.SeasonRenewalDeadlines r ON sh.DimSeasonHeaderId = r.DimSeasonHeaderID
				INNER JOIN dbo.DimTicketType t ON f.DimTicketTypeId = t.DimTicketTypeId
				INNER JOIN dbo.DimPriceCode pc ON f.DimPriceCodeId = pc.DimPriceCodeId
				INNER JOIN dbo.dimitem i ON f.DimItemId = i.DimItemId
				WHERE sh.SeasonName = @Season
					AND t.TicketTypeName NOT IN ('Unknown','Seat Donation', 'Seat Premium', 'Parking', 'TShirt Package')
					--AND pc.PriceCode <> 'AVIS'
					--AND i.ItemCode NOT LIKE '%CHAR'
					--AND ((f.PaidAmount > 0 AND f.TotalRevenue > 0) OR (f.PaidAmount = 0 AND f.TotalRevenue = 0))
				GROUP BY t.TicketTypeName, d.CalDate, DATEDIFF(DAY, r.RenewalDeadline, d.CalDate)
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
							,SUM(DailyRevenue) OVER (ORDER BY TicketTypeName, SaleDate ROWS UNBOUNDED PRECEDING) AS RunningSales
							,SUM(DailyQty) OVER (ORDER BY TicketTypeName, SaleDate ROWS UNBOUNDED PRECEDING) AS RunningQty
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
