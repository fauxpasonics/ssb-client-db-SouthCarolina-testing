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


CREATE PROCEDURE [etl].[TM_LoadFactTicketSales_wPaymentDate_bkp]
AS

SELECT DISTINCT j.order_num
	, j.order_line_item
	, j.acct_id
	, j.event_id
INTO #JournalOrders
FROM ods.TM_Journal j (NOLOCK)  
WHERE j.[type] = 'P'
	AND j.stamp > (GETDATE() - 3)

    
SELECT jo.order_num
	, jo.order_line_item
	, jo.acct_id
	, jo.event_id
	, MIN(CAST(stamp AS DATE)) MinPaymentDate
INTO #JournalOrdersMinDate
FROM ods.TM_Journal j (NOLOCK)
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
--SELECT f.DimDateId, CAST(CONVERT(nvarchar(25), MinPaymentDate, 112) AS INT)
FROM dbo.FactTicketSales (NOLOCK) f
INNER join #JournalOrdersMinDate jomd
	ON f.OrderNum = jomd.order_num
	AND f.OrderLineItem = jomd.order_line_item
	AND f.SSID_event_id = jomd.event_id
	AND f.SSID_acct_id = jomd.acct_id
WHERE f.DimDateId <> CAST(CONVERT(nvarchar(25), MinPaymentDate, 112) AS INT)




GO
