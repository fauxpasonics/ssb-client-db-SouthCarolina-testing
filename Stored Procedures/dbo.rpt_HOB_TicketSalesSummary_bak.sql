SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[rpt_HOB_TicketSalesSummary_bak] (@SeasonName NVARCHAR(100)) 

AS

--DECLARE @SeasonName NVARCHAR(100) SET @SeasonName = '2016 FOOTBALL'


SELECT deh.EventName, deh.EventDate
	, CAST(NULL AS INT) VisitorQty, CAST(NULL AS DECIMAL(15,2))  VisitorRevenue
	, CAST(NULL AS INT) WalkUpQty, CAST(NULL AS DECIMAL(15,2))  WalkUpRevenue
	, SUM(sth.Qty) STHQty, SUM(sth.Revenue) STHRevenue
	, SUM(Mini.Qty) MiniPlanQty, SUM(Mini.Revenue) MiniPlanRevenue
	, SUM(part.Qty) PartialPlanQty, SUM(part.Revenue) PartialPlanRevenue
	, SUM(flex.Qty) FlexPlanQty, SUM(flex.Revenue) FlexPlanRevenue
	, SUM(grp.Qty) GroupQty, SUM(grp.Revenue) GroupRevenue
	, NULL GroupGoal, NULL GroupGoalPct
	, SUM(stu.Qty) StudentQty, SUM(stu.Revenue) StudentRevenue
	, NULL StudentGoal, NULL StudentGoalPct
	, SUM(sg.Qty) SingleGameQty, SUM(sg.Revenue) SingleGameRevenue
	, SUM(tex.Qty) TicketExchangeQty, SUM(tex.Revenue) TicketExchangeRevenue
	, SUM(misc.Qty) MiscQty, SUM(misc.Revenue) MiscRevenue
	, SUM(avail.Qty) AvailableQty, SUM(avail.Revenue) AvailableRevenue
	, SUM(sold.SoldQty) TotalSold
	, SUM(attend.ScanQty) TotalScanned
	, CAST(((CAST(SUM(attend.ScanQty) AS DECIMAL(15,2))/CAST(SUM(sold.SoldQty) AS DECIMAL(15,2))) * 100) AS DECIMAL(15,2)) PctAttended
FROM dbo.DimSeasonHeader ds (NOLOCK)
JOIN dbo.DimEventHeader deh (NOLOCK) ON ds.DimSeasonHeaderId = deh.DimSeasonHeaderId
JOIN dbo.DimEvent de (NOLOCK) ON deh.DimEventHeaderId = de.DimEventHeaderId
LEFT JOIN (
	SELECT DimEventId, SUM(QtySeat) Qty, SUM(TotalRevenue) Revenue
	FROM dbo.FactTicketSales (NOLOCK)
	WHERE DimTicketTypeId = 1
	GROUP BY DimEventId 
	) sth ON de.DimEventId = sth.DimEventId
LEFT JOIN (
	SELECT DimEventId, SUM(QtySeat) Qty, SUM(TotalRevenue) Revenue
	FROM dbo.FactTicketSales (NOLOCK)
	WHERE DimTicketTypeId = 2
	GROUP BY DimEventId
	) mini ON de.DimEventId = mini.DimEventId
LEFT JOIN (
	SELECT DimEventId, SUM(QtySeat) Qty, SUM(TotalRevenue) Revenue
	FROM dbo.FactTicketSales (NOLOCK)
	WHERE DimTicketTypeId = 6
	GROUP BY DimEventId
	) part ON de.DimEventId = part.DimEventId
LEFT JOIN (
	SELECT DimEventId, SUM(QtySeat) Qty, SUM(TotalRevenue) Revenue
	FROM dbo.FactTicketSales (NOLOCK)
	WHERE DimTicketTypeId = 7
	GROUP BY DimEventId
	) flex ON de.DimEventId = flex.DimEventId
LEFT JOIN (
	SELECT DimEventId, SUM(QtySeat) Qty, SUM(TotalRevenue) Revenue
	FROM dbo.FactTicketSales (NOLOCK)
	WHERE DimTicketTypeId = 4
	GROUP BY DimEventId
	) grp ON de.DimEventId = grp.DimEventId
LEFT JOIN (
	SELECT DimEventId, SUM(QtySeat) Qty, SUM(TotalRevenue) Revenue
	FROM dbo.FactTicketSales (NOLOCK)
	WHERE DimSeatTypeId = 11
	GROUP BY DimEventId
	) stu ON de.DimEventId = stu.DimEventId
LEFT JOIN (
	SELECT DimEventId, SUM(QtySeat) Qty, SUM(TotalRevenue) Revenue
	FROM dbo.FactTicketSales (NOLOCK)
	WHERE DimTicketTypeID = 3
	GROUP BY DimEventID
	) sg ON de.DimEventId = sg.DimEventId
LEFT JOIN (
	SELECT event_name, SUM(num_seats) Qty, SUM(te_purchase_price) Revenue
	FROM ods.TM_Tex (NOLOCK)
	WHERE activity = 'ES'
	GROUP BY event_name
	) tex ON de.EventCode = tex.event_name
LEFT JOIN (
	SELECT DimEventId, SUM(QtySeat) Qty, SUM(TotalRevenue) Revenue
	FROM dbo.FactTicketSales (NOLOCK)
	WHERE DimTicketTypeID = 5
	GROUP BY DimEventId
	) mob ON de.DimEventId = mob.DimEventId
LEFT JOIN (
	SELECT DimEventId, SUM(QtySeat) Qty, SUM(TotalRevenue) Revenue
	FROM dbo.FactTicketSales (NOLOCK)
	WHERE DimTicketTypeId = -1
	GROUP BY DimEventId
	) misc ON de.DimEventId = misc.DimEventId
LEFT JOIN (
	SELECT Event_Name, SUM(Num_seats) Qty, SUM(block_full_price) Revenue
	FROM ods.TM_AvailSeats (NOLOCK)
	WHERE class_name = 'DIST-OPEN'
	GROUP BY event_name
	) avail ON de.EventCode = avail.event_name
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
LEFT JOIN (
	SELECT DimEventID, COUNT(DimSeatId) ScanQty
	FROM dbo.FactAttendance (NOLOCK)
	GROUP BY DimEventId
	) attend ON de.DimEventId = attend.DimEventId
WHERE ds.SeasonName = @SeasonName
GROUP BY deh.EventName, deh.EventDate
ORDER BY deh.EventDate



GO
