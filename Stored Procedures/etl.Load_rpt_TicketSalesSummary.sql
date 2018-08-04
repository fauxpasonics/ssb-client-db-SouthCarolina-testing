SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--========================================================================
-- Created by: Kaitlyn Sniffin
-- Created date: 2017-05-24
-- Purpose: Load/reload data to populate TicketSalesSummary portal report
--========================================================================


CREATE PROCEDURE [etl].[Load_rpt_TicketSalesSummary]
AS


-- Clear out staging table --
TRUNCATE TABLE stg.rpt_TicketSalesSummary



-- Load staging table--
INSERT INTO stg.rpt_TicketSalesSummary (SeasonName, EventName, EventDate, VisitorQty, VisitorRevenue, WalkUpQty, WalkUpRevenue, MobileQty, MobileRevenue, STHQty, STHRevenue,
	MiniPlanQty, MiniPlanRevenue, PartialPlanQty, PartialPlanRevenue, FlexPlanQty, FlexPlanRevenue,GroupQty, GroupRevenue, GroupGoal, GroupGoalPct,
	StudentQty, StudentRevenue, StudentGoal, StudentGoalPct, SingleGameQty, SingleGameRevenue, TicketExchangeQty, TicketExchangeRevenue, MiscQty,
	MiscRevenue, AvailableQty, AvailableRevenue, TotalSold, TotalScanned, PctAttended)


SELECT ds.SeasonName
	, deh.EventName
	, deh.EventDate
	, ISNULL(SUM(vis.Qty),0) VisitorQty, ISNULL(SUM(vis.Revenue),0) VisitorRevenue
	, ISNULL(SUM(wlk.Qty),0) WalkUpQty, ISNULL(SUM(wlk.Revenue), 0) WalkUpRevenue
	, ISNULL(SUM(mob.Qty),0) MobileQty, ISNULL(SUM(mob.Revenue), 0) MobileRevenue
	, ISNULL(SUM(sth.Qty),0) STHQty, ISNULL(SUM(sth.Revenue), 0) STHRevenue
	, ISNULL(SUM(Mini.Qty),0) MiniPlanQty, ISNULL(SUM(Mini.Revenue), 0) MiniPlanRevenue
	, ISNULL(SUM(part.Qty),0) PartialPlanQty, ISNULL(SUM(part.Revenue), 0) PartialPlanRevenue
	, ISNULL(SUM(flex.Qty),0) FlexPlanQty, ISNULL(SUM(flex.Revenue), 0) FlexPlanRevenue
	, ISNULL(SUM(grp.Qty),0) GroupQty, ISNULL(SUM(grp.Revenue), 0) GroupRevenue
	, NULL GroupGoal, NULL GroupGoalPct
	, ISNULL(SUM(stu.Qty), 0) StudentQty, ISNULL(SUM(stu.Revenue), 0) StudentRevenue
	, NULL StudentGoal, NULL StudentGoalPct
	, ISNULL(SUM(sg.Qty), 0) SingleGameQty, ISNULL(SUM(sg.Revenue), 0) SingleGameRevenue
	, ISNULL(SUM(tex.Qty), 0) TicketExchangeQty, ISNULL(SUM(tex.Revenue), 0) TicketExchangeRevenue
	, ISNULL(SUM(misc.Qty), 0) MiscQty, ISNULL(SUM(misc.Revenue), 0) MiscRevenue
	, ISNULL(SUM(avail.Qty), 0) AvailableQty, ISNULL(SUM(avail.Revenue), 0) AvailableRevenue
	, ISNULL(SUM(sold.SoldQty), 0) TotalSold
	, ISNULL(SUM(attend.ScanQty),0) TotalScanned
	, CAST((CAST(SUM(attend.ScanQty) AS DECIMAL(15,2))/CAST(SUM(sold.SoldQty) AS DECIMAL(15,2))) AS DECIMAL(15,2)) PctAttended
FROM dbo.DimSeasonHeader ds (NOLOCK)
JOIN dbo.DimEventHeader deh (NOLOCK) ON ds.DimSeasonHeaderId = deh.DimSeasonHeaderId
JOIN dbo.DimEvent de (NOLOCK) ON deh.DimEventHeaderId = de.DimEventHeaderId
LEFT JOIN (
	SELECT DimEventId, SUM(QtySeat) Qty, SUM(TotalRevenue) Revenue
	FROM dbo.FactTicketSales (NOLOCK) f
	JOIN dbo.DimPriceCode p ON f.DimPriceCodeId = p.DimPriceCodeId
	WHERE p.PriceCode = 'AVIS'
	GROUP BY DimEventId 
	) vis ON de.DimEventId = vis.DimEventId
LEFT JOIN (
	SELECT f.DimEventId, SUM(QtySeat) Qty, SUM(TotalRevenue) Revenue
	FROM dbo.FactTicketSales (NOLOCK) f
	JOIN dbo.dimdate d ON f.DimDateId_OrigSale = d.DimDateId
	JOIN dbo.DimEvent e ON f.DimEventId = e.DimEventId
	WHERE d.CalDate = e.EventDate
	GROUP BY f.DimEventId 
	) wlk ON de.DimEventId = wlk.DimEventId
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
GROUP BY ds.SeasonName, deh.EventName, deh.EventDate



-- Load data to rpt table --
SET XACT_ABORT ON

BEGIN TRANSACTION

	TRUNCATE TABLE rpt.TicketSalesSummary



	INSERT INTO rpt.TicketSalesSummary (SeasonName, EventName, EventDate, VisitorQty, VisitorRevenue, WalkUpQty, WalkUpRevenue, MobileQty, MobileRevenue
		, STHQty, STHRevenue, MiniPlanQty, MiniPlanRevenue, PartialPlanQty, PartialPlanRevenue, FlexPlanQty, FlexPlanRevenue,GroupQty, GroupRevenue, GroupGoal
		, GroupGoalPct, StudentQty, StudentRevenue, StudentGoal, StudentGoalPct, SingleGameQty, SingleGameRevenue, TicketExchangeQty, TicketExchangeRevenue
		, MiscQty, MiscRevenue, AvailableQty, AvailableRevenue, TotalSold, TotalScanned, PctAttended)

	SELECT SeasonName
		, EventName
		, EventDate
		, VisitorQty
		, VisitorRevenue
		, WalkUpQty
		, WalkUpRevenue
		, MobileQty
		, MobileRevenue
		, STHQty
		, STHRevenue
		, MiniPlanQty
		, MiniPlanRevenue
		, PartialPlanQty
		, PartialPlanRevenue
		, FlexPlanQty
		, FlexPlanRevenue
		, GroupQty
		, GroupRevenue
		, GroupGoal
		, GroupGoalPct
		, StudentQty
		, StudentRevenue
		, StudentGoal
		, StudentGoalPct
		, SingleGameQty
		, SingleGameRevenue
		, TicketExchangeQty
		, TicketExchangeRevenue
		, MiscQty
		, MiscRevenue
		, AvailableQty
		, AvailableRevenue
		, TotalSold
		, TotalScanned
		, PctAttended
	FROM stg.rpt_TicketSalesSummary

COMMIT TRANSACTION
GO
