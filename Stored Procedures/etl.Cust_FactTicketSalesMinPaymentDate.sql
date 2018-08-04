SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[Cust_FactTicketSalesMinPaymentDate]

AS

BEGIN

-------------------------------------------------------------------------------

-- Author name:		Kaitlyn Nelson
-- Created date:	July 2017
-- Purpose:			Correct DimDateIDs in FactTicketSales to reflect correct
--					original purchase date after box office makes changes that
--					show later dates

-- Copyright © 2017, SSB, All Rights Reserved

-------------------------------------------------------------------------------

-- Modification History --

-- 2018-06-22		Kaitlyn Nelson
-- Change notes:	Added logic to use handling fee dates as original purchase dates

-- Peer reviewed by:	Keegan Schmitt
-- Peer review notes:	Looks good, should be good to go
-- Peer review date:	2018-06-22

-- Deployed by:
-- Deployment date:
-- Deployment notes:

-------------------------------------------------------------------------------

-------------------------------------------------------------------------------

/*====================================================================================================================
	Update DimDateID for all records that have an archived add_datetime that is earlier than the existing DimDateID
	** This corrects for some event reloads the box office did in July, 2017**
====================================================================================================================*/
BEGIN

SELECT acct_id, event_name, event_id, section_name, row_name, num_seats, seat_num, MIN(CAST(add_datetime AS DATE)) add_datetime
	, order_num, order_line_item
INTO #archive
FROM archive.TM_Ticket
WHERE order_num IS NOT NULL AND order_line_item IS NOT NULL
--AND CAST(add_datetime AS DATE) >= (GETDATE() - 365)
GROUP BY acct_id, event_name, event_id, section_name, row_name, num_seats, seat_num, order_num, order_line_item

CREATE NONCLUSTERED INDEX IDX_Key ON #archive (acct_id, event_id, order_num, order_line_item)


UPDATE f
SET f.UpdatedDate = GETDATE()
, f.DimDateId = CAST(CONVERT(nvarchar(25), a.add_datetime, 112) AS INT)
--SELECT FactTicketSalesID, ssid_acct_id, EventCode, DimDateID, CAST(CONVERT(nvarchar(25), a.add_datetime, 112) AS INT) DimDateIDv2, DimDateID_OrigSale
FROM dbo.FactTicketSales (NOLOCK) f 
JOIN dbo.dimevent e ON f.DimEventId = e.DimEventId
INNER join #archive a
	ON f.OrderNum = a.order_num
	AND f.OrderLineItem = a.order_line_item
	AND f.SSID_event_id = a.event_id
	AND f.SSID_acct_id = a.acct_id
WHERE f.DimDateId > CAST(CONVERT(nvarchar(25), a.add_datetime, 112) AS INT)

END


/*====================================================================================================================
	Update DimDateID for all records that have a payment in the TM Journal
====================================================================================================================*/
BEGIN


	SELECT DISTINCT j.order_num, j.order_line_item, j.acct_id, j.event_id
	INTO #JournalOrders
	FROM ods.TM_Journal j
	JOIN ods.TM_Cust c ON j.acct_id = c.acct_id AND c.Primary_code = 'primary'
	WHERE j.type = 'P'-- AND j.stamp > (GETDATE() - 3)
	AND c.acct_type_desc NOT IN ('Department')
	

	
	SELECT jo.order_num, jo.order_line_item, jo.acct_id, jo.event_id, MIN(CAST(stamp AS DATE)) MinPaymentDate
	INTO #JournalOrdersMinDate
	FROM ods.TM_Journal j
	INNER JOIN #JournalOrders jo
		ON j.acct_id = jo.acct_id
		AND j.event_id = jo.event_id
		AND j.order_line_item = jo.order_line_item
		AND j.order_num = jo.order_num
	GROUP BY jo.order_num, jo.order_line_item, jo.acct_id, jo.event_id

	CREATE NONCLUSTERED INDEX IDX_Key ON #JournalOrdersMinDate (acct_id, event_id, order_num, order_line_item)

	UPDATE f
	SET f.UpdatedDate = GETDATE()
	, f.DimDateId = CAST(CONVERT(nvarchar(25), MinPaymentDate, 112) AS INT)
	--SELECT *
	FROM dbo.FactTicketSales (NOLOCK) f 
	INNER join #JournalOrdersMinDate jomd 
	ON f.OrderNum = jomd.order_num
	AND f.OrderLineItem = jomd.order_line_item
	AND f.SSID_event_id = jomd.event_id
	AND f.SSID_acct_id = jomd.acct_id
	WHERE f.DimDateId <> CAST(CONVERT(nvarchar(25), MinPaymentDate, 112) AS INT)


END


/*====================================================================================================================
	Update football plan purchases to reflect the payment date associated with the plan handling fee
	** This corrects for plan expansions when the box office removes the original plan purchase from the account
		in order to sell on the expanded plan**
====================================================================================================================*/
BEGIN

	SELECT f.SSID_acct_id, e.DimEventId, e.EventCode, LEFT(e.EventCode, 4) PlanCode, MIN(f.DimDateId) MinDimDateID
	INTO #HandFeeDates
	FROM dbo.FactTicketSales f (NOLOCK)
	JOIN dbo.DimEvent e (NOLOCK)
		ON f.DimEventId = e.DimEventId
	JOIN dbo.DimSeason s (NOLOCK)
		ON f.DimSeasonId = s.DimSeasonId
	WHERE e.EventCode LIKE '%HAND'
	GROUP BY f.SSID_acct_id, e.DimEventId, e.EventCode, LEFT(e.EventCode, 4)
	ORDER BY e.EventCode

	SELECT f.FactTicketSalesId, f.SSID_acct_id, f.DimDateId, h.PlanCode, h.EventCode, h.MinDimDateID
	INTO #DateDiff
	FROM dbo.FactTicketSales f (NOLOCK)
	JOIN dbo.DimPlan p (NOLOCK)
		ON f.DimPlanId = p.DimPlanId
	JOIN #HandFeeDates h (NOLOCK)
		ON p.PlanCode = h.PlanCode
		AND f.SSID_acct_id = h.SSID_acct_id
	WHERE h.MinDimDateID < f.DimDateId

	UPDATE f
	SET f.DimDateId = d.DimDateId
	FROM dbo.FactTicketSales f (NOLOCK)
	JOIN #DateDiff d (NOLOCK)
		ON f.FactTicketSalesId = d.FactTicketSalesId

END

END
GO
