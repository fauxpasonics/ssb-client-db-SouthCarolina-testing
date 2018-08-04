SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*=============================================================
Procedure:		rpt.RunningDailyQtyRevenue '2016 Football'
Creator:		Travis Hofmeister
Create Date:	2017-05-17
Purpose:		Generate daily sales totals and running sales
				totals for ticket quantities and revenue
=============================================================*/

CREATE PROCEDURE [rpt].[RunningDailyQtyRevenue_bkp] (@Season NVARCHAR(150))
AS

--DECLARE @Season NVARCHAR(150) = '2016 Football';

IF OBJECT_ID('tempdb..#TicketSales') IS NOT NULL
	DROP TABLE #TicketSales
SELECT
     d.CalDate SaleDate
	,t.TicketTypeName
	,DATEDIFF(DAY, r.RenewalDeadline, d.CalDate) DaysOfRenewalCycle
    ,SUM(f.TotalRevenue) AS DailyRevenue
	,SUM(f.QtySeat) AS DailyQty
INTO #TicketSales
FROM dbo.FactTicketSales f
INNER JOIN dbo.DimEvent e ON f.DimEventId = e.DimEventId
INNER JOIN dbo.DimEventHeader eh ON e.DimEventHeaderId = eh.DimEventHeaderId
INNER JOIN dbo.DimSeasonHeader sh ON eh.DimSeasonHeaderId = sh.DimSeasonHeaderId
INNER JOIN dbo.DimDate d ON f.DimDateId = d.DimDateId
INNER JOIN rpt.SeasonRenewalDeadlines r ON sh.DimSeasonHeaderId = r.DimSeasonHeaderID
INNER JOIN dbo.DimTicketType t ON f.DimTicketTypeId = t.DimTicketTypeId
INNER JOIN dbo.DimPriceCode pc ON f.DimPriceCodeId = pc.DimPriceCodeId
INNER JOIN dbo.dimitem i ON f.DimItemId = i.DimItemId
WHERE sh.SeasonName = @Season
	AND t.TicketTypeName NOT IN ('Unknown','Seat Donation', 'Seat Premium', 'Parking', 'TShirt Package')
	AND pc.PriceCode <> 'AVIS'
	AND i.ItemCode NOT LIKE '%CHAR'
	AND ((f.PaidAmount > 0 AND f.TotalRevenue > 0) OR (f.PaidAmount = 0 AND f.TotalRevenue = 0))
GROUP BY t.TicketTypeName, d.CalDate, DATEDIFF(DAY, r.RenewalDeadline, d.CalDate)

SELECT
	 dr.TicketTypeName
    ,dr.SaleDate
	,dr.DaysOfRenewalCycle
    ,dr.DailyRevenue
    ,rt.RunningSales
	,dr.DailyQty
	,rt.RunningQty
FROM #TicketSales dr
INNER JOIN (
        SELECT
			 TicketTypeName
            ,SaleDate
            ,SUM(DailyRevenue) OVER (ORDER BY TicketTypeName, SaleDate ROWS UNBOUNDED PRECEDING) AS RunningSales
			,SUM(DailyQty) OVER (ORDER BY TicketTypeName, SaleDate ROWS UNBOUNDED PRECEDING) AS RunningQty
        FROM #TicketSales
    ) rt 
	ON  dr.SaleDate = rt.SaleDate 
	AND rt.TicketTypeName = dr.TicketTypeName
ORDER BY dr.TicketTypeName, dr.SaleDate


GO
