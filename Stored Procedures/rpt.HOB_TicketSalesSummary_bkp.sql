SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [rpt].[HOB_TicketSalesSummary_bkp] (@SeasonName NVARCHAR(100)) 
AS

--DECLARE @SeasonName NVARCHAR(100) SET @SeasonName = '2016 FOOTBALL';
WITH FirstStep AS
(
	SELECT DimSeasonHeaderId
	FROM dbo.DimSeasonHeader (NOLOCK)
	WHERE SeasonName = @SeasonName
)


SELECT 
	deh.EventName
	,deh.EventDate
	-- Visitor Tickets --
	,SUM(CASE WHEN p.PriceCode = 'AVIS' THEN F.QtySeat ELSE 0 END) AS VisitorQty
	,SUM(CASE WHEN p.PriceCode = 'AVIS' THEN F.TotalRevenue ELSE 0 END) VisitorRevenue
	-- Walk-up Tickets --
	,SUM(CASE WHEN D.CalDate is not null THEN f.QtySeat ELSE 0 END) WalkUpQty
	,SUM(CASE WHEN D.CalDate is not null THEN f.TotalRevenue ELSE 0 END) WalkUpRevenue
	-- Season Tickets --
	,SUM(CASE WHEN DimTicketTypeId = 1 THEN f.QtySeat ELSE 0 END) STHQty
	,SUM(CASE WHEN DimTicketTypeId = 1 THEN f.TotalRevenue ELSE 0 END) STHRevenue
	--- Mini Plan Tickets --
	,SUM(CASE WHEN DimTicketTypeId = 2 THEN f.QtySeat ELSE 0 END) MiniPlanQty
	,SUM(CASE WHEN DimTicketTypeId = 2 THEN f.TotalRevenue ELSE 0 END) MiniPlanRevenue
	-- Partial Plan Tickets --
	,SUM(CASE WHEN DimTicketTypeId = 6 THEN f.QtySeat ELSE 0 END) PartialPlanQty
	,SUM(CASE WHEN DimTicketTypeId = 6 THEN f.TotalRevenue ELSE 0 END) PartialPlanRevenue
	-- Flex Plan Tickets --
	,SUM(CASE WHEN DimTicketTypeId = 7 THEN f.QtySeat ELSE 0 END) FlexPlanQty
	,SUM(CASE WHEN DimTicketTypeId = 7 THEN f.TotalRevenue ELSE 0 END) FlexPlanRevenue
	-- Group Tickets --
	,SUM(CASE WHEN DimTicketTypeId = 4 THEN f.QtySeat ELSE 0 END) GroupQty
	,SUM(CASE WHEN DimTicketTypeId = 4 THEN f.TotalRevenue ELSE 0 END) GroupRevenue
	, NULL GroupGoal
	, NULL GroupGoalPct
	-- Student Tickets --
	,SUM(CASE WHEN DimSeatTypeId = 11 THEN f.QtySeat ELSE 0 END) StudentQty
	,SUM(CASE WHEN DimSeatTypeId = 11 THEN f.TotalRevenue ELSE 0 END) StudentRevenue
	, NULL StudentGoal
	, NULL StudentGoalPct
	-- Single Game Tickets - Public --
	,SUM(CASE WHEN DimTicketTypeID = 3 AND LEN(p.PriceCode) = 1 THEN f.QtySeat ELSE 0 END) SingleGameQty
	,SUM(CASE WHEN DimTicketTypeID = 3 AND LEN(p.PriceCode) = 1 THEN f.TotalRevenue ELSE 0 END) SingleGameRevenue
	-- Single Game Tickets - Archtics --
	,SUM(CASE WHEN DimTicketTypeID = 3 AND p.PriceCode IN ('CEU','DSU','EWU','AP') THEN f.QtySeat ELSE 0 END) ArchticsSingleGameQty
	,SUM(CASE WHEN DimTicketTypeID = 3 AND p.PriceCode IN ('CEU','DSU','EWU','AP') THEN f.TotalRevenue ELSE 0 END) ArchticsSingleGameRevenue
	-- Mobile Tickets --
	,SUM(CASE WHEN SalesCodeName = 'TAP' THEN f.QtySeat ELSE 0 END) MobileQty
	,SUM(CASE WHEN SalesCodeName = 'TAP' THEN f.TotalRevenue ELSE 0 END) MobileRevenue
	-- Miscellaneous Tickets --
	,SUM(CASE WHEN DimTicketTypeID = -1 THEN f.QtySeat ELSE 0 END) MiscQty
	,SUM(CASE WHEN DimTicketTypeID = -1 THEN f.TotalRevenue ELSE 0 END) MiscRevenue
	, ISNULL(MAX(sold.ScanQty),0) TotalSold
	, ISNULL(MAX(attend.ScanQty),0) TotalScanned
	, ISNULL(MAX(avail.Qty), 0) AvailableQty
	, MAX(attend.ScanQty)*1.0/SUM(CASE WHEN ATTEND.DimEventId IS NOT NULL THEN f.QtySeat ELSE 0 END) PctAttended
	-- EXCHANGE TICKETS --
	, ISNULL(MAX(tex.Qty), 0) TicketExchangeQty
	, ISNULL(MAX(tex.Revenue), 0) TicketExchangeRevenue
FROM FirstStep ds (NOLOCK)
JOIN dbo.DimEventHeader deh (NOLOCK) ON ds.DimSeasonHeaderId = deh.DimSeasonHeaderId
JOIN dbo.DimEvent de (NOLOCK) ON deh.DimEventHeaderId = de.DimEventHeaderId
LEFT JOIN dbo.FactTicketSales (NOLOCK) f ON de.DimEventId = f.DimEventId
JOIN dbo.DimPriceCode p ON f.DimPriceCodeId = p.DimPriceCodeId
LEFT JOIN dbo.dimdate d ON f.DimDateId_OrigSale = d.DimDateId AND  d.CalDate = de.EventDate
LEFT JOIN dbo.dimSalesCode sc ON f.DimSalesCodeId = sc.DimSalesCodeId
-- Ticket Exchange Tickets --
LEFT JOIN (
		SELECT event_name, SUM(num_seats) Qty, SUM(te_purchase_price) Revenue
		FROM ods.TM_Tex (NOLOCK)
		WHERE activity = 'ES'
		GROUP BY event_name
) tex ON de.EventCode = tex.event_name
-- Available Tickets --
LEFT JOIN (
		SELECT Event_Name, SUM(Num_seats) Qty--, SUM(block_full_price) Revenue
		FROM ods.TM_AvailSeats (NOLOCK)
		WHERE class_name = 'DIST-OPEN'
		GROUP BY event_name
) avail ON de.EventCode = avail.event_name
-- Attended Tickets --
LEFT JOIN (
		SELECT fa.DimEventID, COUNT(DISTINCT DimSeatId) ScanQty
		FROM dbo.DimSeasonHeader ds (NOLOCK)
		INNER JOIN dbo.DimEventHeader deh (NOLOCK) 
			ON  ds.DimSeasonHeaderId = deh.DimSeasonHeaderId
		INNER JOIN dbo.DimEvent de (NOLOCK) 
			ON  deh.DimEventHeaderId = de.DimEventHeaderId
		INNER JOIN dbo.FactAttendance fa (NOLOCK)
			ON  de.DimEventId = fa.DimEventId
		WHERE ds.SeasonName = @SeasonName
		GROUP BY fa.DimEventId
	) attend ON de.DimEventId = attend.DimEventId
LEFT JOIN (
		SELECT f.DimEventID, SUM(f.QtySeat) ScanQty
		FROM dbo.DimSeasonHeader ds (NOLOCK)
		INNER JOIN dbo.DimEventHeader deh (NOLOCK) 
			ON  ds.DimSeasonHeaderId = deh.DimSeasonHeaderId
		INNER JOIN dbo.DimEvent de (NOLOCK) 
			ON  deh.DimEventHeaderId = de.DimEventHeaderId
		INNER JOIN dbo.FactTicketSales f (NOLOCK)
			ON  de.DimEventId = f.DimEventId
		WHERE ds.SeasonName = @SeasonName
		GROUP BY f.DimEventId
	) sold ON de.DimEventId = sold.DimEventId
WHERE de.EventName NOT LIKE '%Seat Donation%'
GROUP BY deh.EventName, deh.EventDate
ORDER BY DEH.EventDate




GO
