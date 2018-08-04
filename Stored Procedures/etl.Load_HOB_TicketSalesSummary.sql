SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Load_HOB_TicketSalesSummary]
AS

DECLARE @SeasonName NVARCHAR(100)

TRUNCATE TABLE dbo.HOB_TicketSalesSummary


SELECT *
INTO #WorkingSet
FROM rpt.vw_HOB_SeasonMenu



WHILE 1=1
BEGIN
	SELECT TOP 1 @SeasonName = SeasonName
	FROM #WorkingSet

	IF @@ROWCOUNT = 0
		BREAK
	ELSE
		BEGIN
--DECLARE @seasonName NVARCHAR(100) = '2016 Football';

			WITH FirstStep AS
			(
				SELECT DimSeasonHeaderId
				FROM dbo.DimSeasonHeader (NOLOCK)
				WHERE SeasonName = @SeasonName
			)

			, NextStep AS
			(
			SELECT deh.DimEventHeaderId
				, @SeasonName SeasonName
				, deh.EventName
				, CONCAT(DATENAME(dw,deh.EventDate), ', ', deh.EventDate) EventDate
				, deh.EventDate CalendarDate
				-- Visitor Tickets --
				,SUM(CASE WHEN (dsh.DimSeasonHeaderID IN (2, 9, 15, 21, 50, 82, 314, 321, 327) AND p.PriceCode = 'AVIS')
						OR (dsh.DimSeasonHeaderID IN (3, 10, 16, 22, 306, 370) AND vis.ArchticsID IS NOT NULL)
						THEN F.QtySeat ELSE 0 END) AS VisitorQty
				,SUM(CASE WHEN (dsh.DimSeasonHeaderID IN (2, 9, 15, 21, 50, 82, 314, 321, 327) AND p.PriceCode = 'AVIS')
						OR (dsh.DimSeasonHeaderID IN (3, 10, 16, 22, 306, 370)	AND vis.ArchticsID IS NOT NULL)
						THEN F.TotalRevenue ELSE 0 END) VisitorRevenue
				-- Walk-up Tickets --
				,SUM(CASE WHEN D.CalDate is not null AND f.TotalRevenue > 0 THEN f.QtySeat ELSE 0 END) WalkUpQty
				,SUM(CASE WHEN D.CalDate is not null AND f.TotalRevenue > 0 THEN f.TotalRevenue ELSE 0 END) WalkUpRevenue
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
				,deh.Custom_Dec_1 AS GroupGoal
				,CASE WHEN deh.Custom_Dec_1 IS NOT NULL AND deh.Custom_Dec_1 <> 0 THEN (SUM(CASE WHEN DimTicketTypeId = 4 THEN f.QtySeat ELSE 0 END)/deh.Custom_Dec_1) END GroupGoalPct
				-- Student Tickets --
				,SUM(CASE WHEN DimSeatTypeId = 11 OR (D.CalDate is not null AND f.TotalRevenue = 0 AND p.PriceCode NOT IN ('AC', 'FBP', 'TMC')) THEN f.QtySeat ELSE 0 END) StudentQty
				,SUM(CASE WHEN DimSeatTypeId = 11 OR (D.CalDate is not null AND f.TotalRevenue = 0 AND p.PriceCode NOT IN ('AC', 'FBP', 'TMC')) THEN f.TotalRevenue ELSE 0 END) StudentRevenue
				,deh.Custom_Dec_2 AS StudentGoal
				,CASE WHEN deh.Custom_Dec_2 IS NOT NULL AND deh.Custom_Dec_2 <> 0 THEN (SUM(CASE WHEN DimSeatTypeId = 11 THEN f.QtySeat ELSE 0 END)/deh.Custom_Dec_2) END StudentGoalPct
				-- Single Game Tickets - Public --
				,SUM(CASE WHEN DimTicketTypeID = 3
							AND ((dsh.DimSeasonHeaderID IN (2, 9, 15, 21) AND LEN(PriceCode) = 1)
							OR (dsh.DimSeasonHeaderID IN (3, 10, 16, 22) AND p.PriceCode IN ('1', '2', '4', '5', 'A', 'B', 'C', 'D', 'G', 'H', 'J', 'K') AND f.IsHost = 1)) THEN f.QtySeat ELSE 0 END) SingleGameQty
				,SUM(CASE WHEN DimTicketTypeID = 3
							AND ((dsh.DimSeasonHeaderID IN (2, 9, 15, 21) AND LEN(PriceCode) = 1)
							OR (dsh.DimSeasonHeaderID IN (3, 10, 16, 22) AND p.PriceCode IN ('1', '2', '4', '5', 'A', 'B', 'C', 'D', 'G', 'H', 'J', 'K') AND f.IsHost = 1)) THEN f.TotalRevenue ELSE 0 END) SingleGameRevenue
				-- Single Game Tickets - Archtics --
				,SUM(CASE WHEN DimTicketTypeID = 3
							AND ((dsh.DimSeasonHeaderID IN (2, 9, 15, 21) AND p.PriceCode IN ('CEU','DSU','EWU','AP'))
							OR (dsh.DimSeasonHeaderID IN (10) AND p.PriceCode IN ('ABL', 'AIMG', 'BBM'))
							OR (dsh.DimSeasonHeaderID IN (3, 10, 16, 22) AND p.PriceCode IN ('2PP', '1LG', '1LP', '1TV', '2FM', '2UG', '2UP', '2WS', '4FM', '5FM', 'APW'))) THEN f.QtySeat
						ELSE 0 END) ArchticsSingleGameQty
				,SUM(CASE WHEN DimTicketTypeID = 3
							AND ((dsh.DimSeasonHeaderID IN (2, 9, 15, 21) AND p.PriceCode IN ('CEU','DSU','EWU','AP'))
							OR (dsh.DimSeasonHeaderID IN (10) AND p.PriceCode IN ('ABL', 'AIMG', 'BBM'))
							OR (dsh.DimSeasonHeaderID IN (3) AND p.PriceCode IN ('2PP', '1LG', '1LP', '1TV', '2FM', '2UG', '2UP', '2WS', '4FM', '5FM', 'APW'))) THEN f.TotalRevenue
						ELSE 0 END) ArchticsSingleGameRevenue
				-- Mobile Tickets --
				, ISNULL(MAX(mob.Qty),0) MobileQty
				, ISNULL(MAX(mob.Revenue), 0.00) MobileRevenue
				, ISNULL(MAX(sold.ScanQty),0) TotalSold
				, ISNULL(MAX(attend.ScanQty),0) TotalScanned
				, ISNULL(MAX(avail.Qty), 0) AvailableQty
				, MAX(attend.ScanQty)*1.0/SUM(CASE WHEN ATTEND.DimEventId IS NOT NULL THEN f.QtySeat ELSE 0 END) PctAttended
				-- EXCHANGE TICKETS --
				, ISNULL(MAX(tex.Qty), 0) TicketExchangeQty
				, ISNULL(MAX(tex.Revenue), 0) TicketExchangeRevenue
				, ISNULL(SUM(f.TotalRevenue),0) TotalRevenue
			FROM FirstStep dsh (NOLOCK)
			JOIN dbo.DimSeason ds (NOLOCK)
				ON dsh.DimSeasonHeaderId = ds.Config_DefaultDimSeasonHeaderID
			LEFT JOIN dbo.FactTicketSales f (NOLOCK)
				ON ds.DimSeasonID = f.DimSeasonID
			JOIN dbo.DimEvent de (NOLOCK)
				ON f.DimEventID = de.DimEventID
			JOIN dbo.DimEventHeader deh (NOLOCK)
				ON de.DimEventHeaderId = deh.DimEventHeaderId
			JOIN dbo.DimPriceCode p (NOLOCK)
				ON f.DimPriceCodeId = p.DimPriceCodeId
			LEFT JOIN dbo.dimdate d (NOLOCK)
				ON f.DimDateId_OrigSale = d.DimDateId
				AND  d.CalDate = de.EventDate
			LEFT JOIN dbo.dimSalesCode sc (NOLOCK)
				ON f.DimSalesCodeId = sc.DimSalesCodeId
			LEFT JOIN dbo.VisitingTeamArchticsAccounts vis (NOLOCK)
				ON f.SSID_acct_id = vis.ArchticsID
			-- Ticket Exchange Tickets --
			LEFT JOIN (
					SELECT event_name, SUM(num_seats) Qty, SUM(te_purchase_price) Revenue
					FROM ods.TM_Tex (NOLOCK)
					WHERE activity = 'ES'
					GROUP BY event_name
			) tex ON de.EventCode = tex.event_name
			-- Mobile Tickets --
			LEFT JOIN (
					SELECT event_name, SUM(num_seats) Qty, SUM(block_purchase_price) Revenue
					FROM ods.TM_vw_Ticket (NOLOCK)
					WHERE sell_location = 'TAP'
					GROUP BY event_name
			) mob ON de.EventCode = mob.event_name
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
					FROM dbo.DimSeasonHeader dsh (NOLOCK)
					INNER JOIN dbo.DimSeason ds (NOLOCK)
						ON dsh.DimSeasonHeaderId = ds.Config_DefaultDimSeasonHeaderID
					INNER JOIN dbo.DimEvent de (NOLOCK) 
						ON  ds.DimSeasonID = de.DimSeasonID
					INNER JOIN dbo.FactAttendance fa (NOLOCK)
						ON  de.DimEventID = fa.DimEventId
					WHERE dsh.SeasonName = @SeasonName
					GROUP BY fa.DimEventId
				) attend ON de.DimEventId = attend.DimEventId
			LEFT JOIN (
					SELECT f.DimEventID, SUM(f.QtySeat) ScanQty
					FROM dbo.DimSeasonHeader dsh (NOLOCK)
					INNER JOIN dbo.DimSeason ds (NOLOCK)
						ON dsh.DimSeasonHeaderId = ds.Config_DefaultDimSeasonHeaderId
					INNER JOIN dbo.DimEvent de (NOLOCK) 
						ON  ds.DimSeasonId = de.DimSeasonId
					INNER JOIN dbo.FactTicketSales f (NOLOCK)
						ON  de.DimEventId = f.DimEventId
					WHERE dsh.SeasonName = @SeasonName
					GROUP BY f.DimEventId
				) sold ON de.DimEventId = sold.DimEventId
			WHERE de.EventName NOT LIKE '%Seat Donation%'
			GROUP BY deh.DimEventHeaderId, deh.EventName, deh.EventDate, deh.Custom_Dec_1, deh.Custom_Dec_2
			)


			INSERT INTO dbo.HOB_TicketSalesSummary (DimEventHeaderID, SeasonName, EventName, EventDate, CalendarDate, VisitorQty, VisitorRevenue, WalkUpQty,
			WalkUpRevenue, STHQty, STHRevenue, MiniPlanQty, MiniPlanRevenue, PartialPlanQty, PartialPlanRevenue,
			FlexPlanQty, FlexPlanRevenue, GroupQty, GroupRevenue, GroupGoal, GroupGoalPct, StudentQty, StudentRevenue,
			StudentGoal, StudentGoalPct, SingleGameQty, SingleGameRevenue, ArchticsSingleGameQty, ArchticsSingleGameRevenue,
			MobileQty, MobileRevenue, TotalSingleGameSales, TotalSingleGameSalesRevenue, TotalSold, TotalScanned, AvailableQty, PctAttended, TicketExchangeQty,
			TicketExchangeRevenue, TotalRevenue)

			SELECT DimEventHeaderID, SeasonName, NextStep.EventName, EventDate, CalendarDate, NextStep.VisitorQty, NextStep.VisitorRevenue, NextStep.WalkUpQty, NextStep.WalkUpRevenue
				, NextStep.STHQty, NextStep.STHRevenue, NextStep.MiniPlanQty, NextStep.MiniPlanRevenue, NextStep.PartialPlanQty, NextStep.PartialPlanRevenue
				, NextStep.FlexPlanQty, NextStep.FlexPlanRevenue, NextStep.GroupQty, NextStep.GroupRevenue, NextStep.GroupGoal, NextStep.GroupGoalPct, NextStep.StudentQty, NextStep.StudentRevenue
				, NextStep.StudentGoal, NextStep.StudentGoalPct, NextStep.SingleGameQty, NextStep.SingleGameRevenue, NextStep.ArchticsSingleGameQty, NextStep.ArchticsSingleGameRevenue
				, NextStep.MobileQty, NextStep.MobileRevenue, (NextStep.VisitorQty + NextStep.ArchticsSingleGameQty + NextStep.SingleGameQty + NextStep.GroupQty + NextStep.MobileQty + NextStep.WalkUpQty) AS TotalSingleGameSales
				, (NextStep.VisitorRevenue + NextStep.ArchticsSingleGameRevenue + NextStep.SingleGameRevenue + NextStep.GroupRevenue + NextStep.MobileRevenue + NextStep.WalkUpRevenue) AS TotalSingleGameSalesRevenue
				, NextStep.TotalSold, NextStep.TotalScanned, NextStep.AvailableQty, NextStep.PctAttended, NextStep.TicketExchangeQty, NextStep.TicketExchangeRevenue
				, NextStep.TotalRevenue
			FROM NextStep
			WHERE NextStep.EventName NOT LIKE '%Donation%'
			ORDER BY EventDate


			;

			DELETE
			FROM #WorkingSet
			WHERE SeasonName = @SeasonName
			;

		END
		;

	CONTINUE
	;

END
;


GO
