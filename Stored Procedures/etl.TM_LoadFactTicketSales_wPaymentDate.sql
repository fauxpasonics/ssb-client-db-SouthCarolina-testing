SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--======================================================================
-- Created by:		Kaitlyn Sniffin and Zach Frick
-- Created date:	2017-06-06
-- Purpose:			Update FactTicketSales DimDateID to reflect the
--					min payment date (if exists), not the add_datetime
--======================================================================


CREATE PROCEDURE [etl].[TM_LoadFactTicketSales_wPaymentDate]
AS


BEGIN
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
		AND CAST(add_datetime AS DATE) >= (GETDATE() - 365)
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

		SELECT j.order_num
			--, j.order_line_item
			, j.acct_id
			--, j.event_id
			, MIN(CAST(stamp AS DATE)) MinPaymentDate
		INTO #JournalOrders
		FROM ods.TM_Journal j (NOLOCK)  
		WHERE j.[type] = 'P' OR j.[type_desc] = 'Pay Detail'
			AND j.stamp > (GETDATE() - 3)
			AND j.credit >= 0
		GROUP BY j.order_num, j.acct_id--, j.event_id, j.order_line_item

		CREATE NONCLUSTERED INDEX IDX_Key ON #JournalOrders (acct_id, /*event_id,*/ order_num, /*order_line_item,*/ MinPaymentDate)


		UPDATE f
		SET f.UpdatedDate = GETDATE()
		, f.DimDateId = CAST(CONVERT(nvarchar(25), jo.MinPaymentDate, 112) AS INT)
		--SELECT f.DimDateId, CAST(CONVERT(nvarchar(25), MinPaymentDate, 112) AS INT)
		FROM dbo.FactTicketSales (NOLOCK) f
		INNER join #JournalOrders jo
			ON f.OrderNum = jo.order_num
			--AND f.OrderLineItem = jo.order_line_item
			--AND f.SSID_event_id = jo.event_id
			AND f.SSID_acct_id = jo.acct_id
		WHERE f.DimDateId <> CAST(CONVERT(nvarchar(25), jo.MinPaymentDate, 112) AS INT)

	END


/*====================================================================================================================
	Update QtySeatFSE
====================================================================================================================*/
BEGIN

SELECT f.FactTicketSalesId, 
		CASE WHEN p.DimPlanId > 0
					AND LEFT(p.PlanCode, 2) IN ('BB', 'BS', 'FB', 'MS', 'SB', 'VB', 'WB', 'WS')
					AND LEN(p.PlanCode) = 4
				THEN CAST(f.QtySeat AS DECIMAL(18,6))/NULLIF(CAST(p.PlanEventCnt AS DECIMAL(18,6)), 0)
			WHEN e.EventCode LIKE '%DEP%'
				THEN f.QtySeat
			WHEN p.DimPlanId > 0 AND (LEN(p.PlanCode) <> 4
					OR (LEN(p.PlanCode) = 4 AND LEFT(p.PlanCode, 2) NOT IN ('BB', 'BS', 'FB', 'MS', 'SB', 'VB', 'WB', 'WS')))
				THEN f.QtySeatFSE
			ELSE 0 END AS QtySeatFSE
INTO #QtySeatFSE
FROM dbo.FactTicketSales f (NOLOCK)
JOIN dbo.DimEvent e (NOLOCK)
	ON f.DimEventId = e.DimEventId
JOIN dbo.DimPlan p (NOLOCK)
	ON f.DimPlanId = p.DimPlanId
JOIN dbo.DimSeason s (NOLOCK)
	ON f.DimSeasonId = s.DimSeasonId


UPDATE a
SET a.QtySeatFSE = b.QtySeatFSE
FROM dbo.FactTicketSales a (NOLOCK)
JOIN #QtySeatFSE b
	ON a.FactTicketSalesId = b.FactTicketSalesId
WHERE ISNULL(a.QtySeatFSE, 0) <> ISNULL(b.QtySeatFSE, 0)

END

END



GO
