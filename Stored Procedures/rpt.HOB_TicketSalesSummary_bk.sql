SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create PROCEDURE [rpt].[HOB_TicketSalesSummary_bk] (@SeasonName NVARCHAR(100)) 

AS

--DECLARE @SeasonName NVARCHAR(100) SET @SeasonName = '2016 FOOTBALL';
WITH FirstStep AS
(
	SELECT DimSeasonHeaderId
	FROM dbo.DimSeasonHeader (NOLOCK)
	WHERE SeasonName = @SeasonName
)


SELECT deh.EventName, deh.EventDate
	, ISNULL(SUM(vis.Qty),0) VisitorQty, ISNULL(SUM(vis.Revenue),0)  VisitorRevenue
	, ISNULL(SUM(wlk.Qty),0) WalkUpQty, ISNULL(SUM(wlk.Revenue), 0)  WalkUpRevenue
	, ISNULL(SUM(sth.Qty),0) STHQty, ISNULL(SUM(sth.Revenue), 0) STHRevenue
	, ISNULL(SUM(Mini.Qty),0) MiniPlanQty, ISNULL(SUM(Mini.Revenue), 0) MiniPlanRevenue
	, ISNULL(SUM(part.Qty),0) PartialPlanQty, ISNULL(SUM(part.Revenue), 0) PartialPlanRevenue
	, ISNULL(SUM(flex.Qty),0) FlexPlanQty, ISNULL(SUM(flex.Revenue), 0) FlexPlanRevenue
	, ISNULL(SUM(grp.Qty),0) GroupQty, ISNULL(SUM(grp.Revenue), 0) GroupRevenue
	, NULL GroupGoal, NULL GroupGoalPct
	, ISNULL(SUM(stu.Qty), 0) StudentQty, ISNULL(SUM(stu.Revenue), 0) StudentRevenue
	, NULL StudentGoal, NULL StudentGoalPct
	, ISNULL(SUM(sgp.Qty), 0) SingleGameQty, ISNULL(SUM(sgp.Revenue), 0) SingleGameRevenue
	, ISNULL(SUM(sga.Qty), 0) SingleGameQty, ISNULL(SUM(sga.Revenue), 0) ArchticsSingleGameRevenue
	, ISNULL(SUM(tex.Qty), 0) TicketExchangeQty, ISNULL(SUM(tex.Revenue), 0) TicketExchangeRevenue
	, ISNULL(SUM(misc.Qty), 0) MiscQty, ISNULL(SUM(misc.Revenue), 0) MiscRevenue
	, ISNULL(SUM(avail.Qty), 0) AvailableQty, ISNULL(SUM(avail.Revenue), 0) AvailableRevenue
	, ISNULL(SUM(sold.SoldQty), 0) TotalSold
	, ISNULL(SUM(attend.ScanQty),0) TotalScanned
	, CAST((CAST(SUM(attend.ScanQty) AS DECIMAL(15,2))/CAST(SUM(sold.SoldQty) AS DECIMAL(15,2))) AS DECIMAL(15,2)) PctAttended
FROM FirstStep ds (NOLOCK)
JOIN dbo.DimEventHeader deh (NOLOCK) ON ds.DimSeasonHeaderId = deh.DimSeasonHeaderId
JOIN dbo.DimEvent de (NOLOCK) ON deh.DimEventHeaderId = de.DimEventHeaderId
-- Visitor Tickets --
LEFT JOIN (
	SELECT DimEventId, SUM(QtySeat) Qty, SUM(TotalRevenue) Revenue
	FROM dbo.FactTicketSales (NOLOCK) f
	JOIN dbo.DimPriceCode p ON f.DimPriceCodeId = p.DimPriceCodeId
	WHERE p.PriceCode = 'AVIS'
	GROUP BY DimEventId 
	) vis ON de.DimEventId = vis.DimEventId
-- Walk-up Tickets --
LEFT JOIN (
	SELECT f.DimEventId, SUM(QtySeat) Qty, SUM(TotalRevenue) Revenue
	FROM dbo.FactTicketSales (NOLOCK) f
	JOIN dbo.dimdate d ON f.DimDateId_OrigSale = d.DimDateId
	JOIN dbo.DimEvent e ON f.DimEventId = e.DimEventId
	WHERE d.CalDate = e.EventDate
	GROUP BY f.DimEventId 
	) wlk ON de.DimEventId = wlk.DimEventId
-- Season Tickets --
LEFT JOIN (
	SELECT DimEventId, SUM(QtySeat) Qty, SUM(TotalRevenue) Revenue
	FROM dbo.FactTicketSales (NOLOCK)
	WHERE DimTicketTypeId = 1
	GROUP BY DimEventId 
	) sth ON de.DimEventId = sth.DimEventId
--- Mini Plan Tickets --
LEFT JOIN (
	SELECT DimEventId, SUM(QtySeat) Qty, SUM(TotalRevenue) Revenue
	FROM dbo.FactTicketSales (NOLOCK)
	WHERE DimTicketTypeId = 2
	GROUP BY DimEventId
	) mini ON de.DimEventId = mini.DimEventId
-- Partial Plan Tickets --
LEFT JOIN (
	SELECT DimEventId, SUM(QtySeat) Qty, SUM(TotalRevenue) Revenue
	FROM dbo.FactTicketSales (NOLOCK)
	WHERE DimTicketTypeId = 6
	GROUP BY DimEventId
	) part ON de.DimEventId = part.DimEventId
-- Flex Plan Tickets --
LEFT JOIN (
	SELECT DimEventId, SUM(QtySeat) Qty, SUM(TotalRevenue) Revenue
	FROM dbo.FactTicketSales (NOLOCK)
	WHERE DimTicketTypeId = 7
	GROUP BY DimEventId
	) flex ON de.DimEventId = flex.DimEventId
-- Group Tickets --
LEFT JOIN (
	SELECT DimEventId, SUM(QtySeat) Qty, SUM(TotalRevenue) Revenue
	FROM dbo.FactTicketSales (NOLOCK)
	WHERE DimTicketTypeId = 4
	GROUP BY DimEventId
	) grp ON de.DimEventId = grp.DimEventId
-- Student Tickets --
LEFT JOIN (
	SELECT DimEventId, SUM(QtySeat) Qty, SUM(TotalRevenue) Revenue
	FROM dbo.FactTicketSales (NOLOCK)
	WHERE DimSeatTypeId = 11
	GROUP BY DimEventId
	) stu ON de.DimEventId = stu.DimEventId
-- Single Game Tickets - Public --
LEFT JOIN (
	SELECT DimEventId, SUM(QtySeat) Qty, SUM(TotalRevenue) Revenue
	FROM dbo.FactTicketSales (NOLOCK) f
	JOIN dbo.DimPriceCode p ON f.DimPriceCodeID = p.DimPriceCodeId
	WHERE DimTicketTypeID = 3
	AND p.PriceCode NOT IN ('CEU','DSU','EWU','AP')
	GROUP BY DimEventID
	) sgp ON de.DimEventId = sgp.DimEventId
-- Single Game Tickets - Archtics --
LEFT JOIN (
	SELECT DimEventId, SUM(QtySeat) Qty, SUM(TotalRevenue) Revenue
	FROM dbo.FactTicketSales (NOLOCK) f
	JOIN dbo.DimPriceCode p ON f.DimPriceCodeID = p.DimPriceCodeId
	WHERE DimTicketTypeID = 3
	AND p.PriceCode IN ('CEU','DSU','EWU','AP')
	GROUP BY DimEventID
	) sga ON de.DimEventId = sga.DimEventId
-- Ticket Exchange Tickets --
LEFT JOIN (
	SELECT event_name, SUM(num_seats) Qty, SUM(te_purchase_price) Revenue
	FROM ods.TM_Tex (NOLOCK)
	WHERE activity = 'ES'
	GROUP BY event_name
	) tex ON de.EventCode = tex.event_name
-- Mobile Tickets --
LEFT JOIN (
	SELECT DimEventId, SUM(QtySeat) Qty, SUM(TotalRevenue) Revenue
	FROM dbo.FactTicketSales (NOLOCK)
	WHERE DimTicketTypeID = 5
	GROUP BY DimEventId
	) mob ON de.DimEventId = mob.DimEventId
-- Miscellaneous Tickets --
LEFT JOIN (
	SELECT DimEventId, SUM(QtySeat) Qty, SUM(TotalRevenue) Revenue
	FROM dbo.FactTicketSales (NOLOCK)
	WHERE DimTicketTypeId = -1
	GROUP BY DimEventId
	) misc ON de.DimEventId = misc.DimEventId
-- Available Tickets --
LEFT JOIN (
	SELECT Event_Name, SUM(Num_seats) Qty, SUM(block_full_price) Revenue
	FROM ods.TM_AvailSeats (NOLOCK)
	WHERE class_name = 'DIST-OPEN'
	GROUP BY event_name
	) avail ON de.EventCode = avail.event_name
-- Sold Tickets --
LEFT JOIN (
	SELECT A.DimEventID, SUM(qtySeat) SoldQty
	FROM dbo.FactTicketSales (NOLOCK) A 
	JOIN (
		SELECT DimEventID, COUNT(DimSeatId) ScanQty
		FROM dbo.FactAttendance (NOLOCK)
		GROUP BY DimEventId
		) B ON a.DimEventId = B.DimEventId
	GROUP BY A.DimEventId
	) sold ON de.DimEventId = sold.DimEventId
-- Attended Tickets --
LEFT JOIN (
	SELECT DimEventID, COUNT(DimSeatId) ScanQty
	FROM dbo.FactAttendance (NOLOCK)
	GROUP BY DimEventId
	) attend ON de.DimEventId = attend.DimEventId
WHERE de.EventName NOT LIKE '%Seat Donation%'
GROUP BY deh.EventName, deh.EventDate
ORDER BY deh.EventDate




GO
