SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [api].[GetTransactions_Bkp_rjordheim_20170321]
@SSB_CRMSYSTEM_ACCT_ID VARCHAR(50) = 'Test',
@SSB_CRMSYSTEM_CONTACT_ID VARCHAR(50) = 'Test',
@DisplayTable INT = 0,
@RowsPerPage  INT = 500,
@PageNumber   INT = 0
AS
    BEGIN 

-- Init vars needed for API
DECLARE @totalCount         INT,
		@xmlDataNode        XML,
		@recordsInResponse  INT,
		@remainingCount     INT,
		@rootNodeName       NVARCHAR(100),
		@responseInfoNode   NVARCHAR(MAX),
		@finalXml           XML


--DECLARE @SSB_CRMSYSTEM_ACCT_ID VARCHAR(50) = 'D7BEF141-C476-4709-BBF2-97BADD986E3D'
--DECLARE @SSB_CRMSYSTEM_CONTACT_ID VARCHAR(50) = 'Test'
--DECLARE	@RowsPerPage  INT = 500, @PageNumber   INT = 0
--DECLARE @DisplayTable INT = 0

--PRINT 'Acct-' + @SSB_CRMSYSTEM_ACCT_ID
--PRINT 'Contact-' + @SSB_CRMSYSTEM_CONTACT_ID

DECLARE @GUIDTable TABLE (
GUID VARCHAR(50)
)

IF (@SSB_CRMSYSTEM_ACCT_ID NOT IN ('None','Test'))
BEGIN
	INSERT INTO @GUIDTable
	        ( GUID )
	SELECT DISTINCT z.SSB_CRMSYSTEM_CONTACT_ID
		FROM dbo.vwDimCustomer_ModAcctId z 
		WHERE z.SSB_CRMSYSTEM_ACCT_ID = @SSB_CRMSYSTEM_ACCT_ID
END

IF (@SSB_CRMSYSTEM_CONTACT_ID NOT IN ('None','Test'))
BEGIN
	INSERT INTO @GUIDTable
	        ( GUID )
	SELECT @SSB_CRMSYSTEM_CONTACT_ID
END




SELECT * INTO #tmpBase
FROM (
SELECT DISTINCT
        'Gamecocks' AS Team
      , fts.SSID_acct_id AS Archtics_ID
      , ds.SeasonName AS Season_Name
	  , de.EventName AS Event_Name
      , fts.OrderNum AS Order_Number
      , fts.OrderLineItem AS Order_Line
      , dd.CalDate AS Order_Date
      , di.ItemCode AS Item
      , di.ItemName AS Item_Name
	  , de.EventDate AS Event_Date
      , dpc.PriceCode AS Price_Code
      , fts.IsComp AS Is_Comp
      , dp2.PromoCode AS Promo_Code
      , fts.QtySeat AS Qty
      , ds2.SectionName AS Section_Name
      , ds2.RowName AS Row_Name
      , CONVERT(NVARCHAR, ds2.Seat) + ':' + CONVERT(NVARCHAR, ( ds2.Seat + fts.QtySeat - 1 )) Seat_Block
      , fts.PcPrice AS Seat_Price
      , fts.BlockPurchasePrice AS Block_Purchase_Price
      , fts.OwedAmount AS Owed_Amount
      , fts.PaidAmount AS Paid_Amount
	  , fts.SSCreatedBy AS Sales_Rep
FROM    dbo.FactTicketSales AS fts
        JOIN dbo.dimcustomerssbid AS d ON d.DimCustomerId = fts.DimCustomerId
        JOIN dbo.DimSeason AS ds ON ds.DimSeasonId = fts.DimSeasonId
        JOIN dbo.DimItem AS di ON di.DimItemId = fts.DimItemId
        JOIN dbo.DimPriceCode AS dpc ON dpc.DimPriceCodeId = fts.DimPriceCodeId
        JOIN dbo.DimTicketClass AS dtc ON dtc.DimTicketClassId = fts.DimTicketTypeId
        JOIN dbo.DimTicketType AS dtt ON fts.DimTicketTypeId = fts.DimTicketTypeId
        JOIN dbo.DimPlan AS dp ON dp.DimPlanId = fts.DimPlanId
        JOIN dbo.DimDate AS dd ON dd.DimDateId = fts.DimDateId
		JOIN dbo.DimEvent AS de ON de.DimEventId = fts.DimEventId
        JOIN dbo.DimPromo AS dp2 ON dp2.DimPromoID = fts.DimPromoId
        JOIN dbo.DimSeat AS ds2 ON ds2.DimSeatId = fts.DimSeatIdStart
WHERE ISNULL([d].[SSB_CRMSYSTEM_ACCT_ID],[d].[SSB_CRMSYSTEM_CONTACT_ID]) IN (SELECT GUID FROM @GUIDTable)
) x

SELECT 
  ISNULL(Team,'') Team
, ISNULL(Archtics_ID,'') Archtics_ID
, ISNULL(Season_Name,'') Season_Name
, ISNULL(Event_Name,'') Event_Name
, ISNULL(Order_Number,'') Order_Number
, ISNULL(Order_Line,'') Order_Line_Item
, ISNULL(Order_Date,'') Order_Date
, ISNULL(Item,'') Item
, ISNULL(Item_Name,'') Item_Name
, ISNULL(Event_Date,'') Event_Date
, ISNULL(Price_Code,'') Price_code
, ISNULL(Is_Comp,'') Is_Comp
, ISNULL(Promo_Code,'') Promo_Code
, ISNULL(Qty,'') Qty
, ISNULL(Section_Name,'') Section_Name
, ISNULL(Row_Name,'') Row_Name
, ISNULL(Seat_Block,'')	Seat_Block
, ISNULL(Seat_Price,'') Seat_Price
, ISNULL(Block_Purchase_Price,'') Block_Purchase_Price
, ISNULL(Owed_Amount,'') Owed_Amount
, ISNULL(Paid_Amount,'') Paid_Amount
, ISNULL(Sales_Rep,'') Sales_Rep
INTO #tmpOutput
FROM #tmpBase
ORDER BY Event_Date, Order_Date
OFFSET (@PageNumber) * @RowsPerPage ROWS
FETCH NEXT @RowsPerPage ROWS ONLY

--SELECT * FROM #tmpBase
--SELECT 
--CAST(Season_Year AS VARCHAR(50)) + ' ' + Ticket_Type_Name Ticket_Type
--, Tier1
--, Season_Year
--, Ticket_Type_Name
--, CASE WHEN SIGN(SUM(Paid_Amount))<0 THEN '-' ELSE '' END + '$' + ISNULL(CONVERT(VARCHAR(12),ABS( CAST(SUM(Paid_Amount) AS DECIMAL(18,2)))), '0.00') AS Paid_Amount
--, CASE WHEN SIGN(SUM(Block_Purchase_Price))<0 THEN '-' ELSE '' END + '$' + ISNULL(CONVERT(VARCHAR(12),ABS( CAST(SUM(Block_Purchase_Price) AS DECIMAL(18,2) ))), '0.00') AS Order_Value
--, CAST(ISNULL(SUM(Paid_Amount) / NULLIF(CAST(SUM(Block_Purchase_Price) AS FLOAT),0),0)*100 AS VARCHAR(50)) + '%' AS 'Paid'
--INTO #tmpParent
--FROM #tmpBase
--GROUP BY CAST(Season_Year AS VARCHAR(50)) + ' ' + Ticket_Type_Name, Season_Year, Ticket_Type_Name, tier1
-- DROP TABLE #tmpParent

-- Pull counts
SELECT @recordsInResponse = COUNT(*) FROM #tmpOutput
SELECT @totalCount = COUNT(*) FROM #tmpBase

SET @xmlDataNode = (
		SELECT * FROM #tmpOutput
		FOR XML PATH ('Record'), ROOT('Records'))

SET @rootNodeName = 'Records'

-- Calculate remaining count
SET @remainingCount = @totalCount - (@RowsPerPage * (@PageNumber + 1))
IF @remainingCount < 0
BEGIN
	SET @remainingCount = 0
END

-- Create response info node
SET @responseInfoNode = ('<ResponseInfo>'
	+ '<TotalCount>' + CAST(@totalCount AS NVARCHAR(20)) + '</TotalCount>'
	+ '<RemainingCount>' + CAST(@remainingCount AS NVARCHAR(20)) + '</RemainingCount>'
	+ '<RecordsInResponse>' + CAST(@recordsInResponse AS NVARCHAR(20)) + '</RecordsInResponse>'
	+ '<PagedResponse>true</PagedResponse>'
	+ '<RowsPerPage>' + CAST(@RowsPerPage AS NVARCHAR(20)) + '</RowsPerPage>'
	+ '<PageNumber>' + CAST(@PageNumber AS NVARCHAR(20)) + '</PageNumber>'
	+ '<RootNodeName>' + @rootNodeName + '</RootNodeName>'
	+ '</ResponseInfo>')

	PRINT @responseInfoNode
	
-- Wrap response info and data, then return	
IF @xmlDataNode IS NULL
BEGIN
	SET @xmlDataNode = '<' + @rootNodeName + ' />' 
END
		
SET @finalXml = '<Root>' + @responseInfoNode + CAST(@xmlDataNode AS NVARCHAR(MAX)) + '</Root>'

IF @DisplayTable = 1
SELECT * FROM #tmpBase

IF @DisplayTable = 0
SELECT CAST(@finalXml AS XML)

DROP TABLE #tmpBase
DROP TABLE #tmpOutput

 END



/*
DECLARE @SSB_CONTACT_GUID VARCHAR(50)

SELECT @SSB_CONTACT_GUID = SSB_CRMSYSTEM_CONTACT_ID FROM dbo.dimcustomerssbid
WHERE DimCustomerId = @DimCustomerID

SELECT SSID AS SourceSystemID,
SourceSystem,
FirstName,
LastName,
MiddleName,
AddressPrimaryStreet,AddressPrimarySuite,AddressPrimaryCity,AddressPrimaryState,AddressPrimaryZip,PhonePrimary, EmailPrimary, @SSB_CONTACT_GUID AS SSBGUID,
ds.SSB_CRMSYSTEM_PRIMARY_FLAG AS IsPrimary,
dc.CustomerType
 FROM dimcustomer dc JOIN (SELECT DimCustomerId, SSB_CRMSYSTEM_PRIMARY_FLAG FROM dimcustomerssbid WHERE SSB_CRMSYSTEM_CONTACT_ID = @SSB_CONTACT_GUID) ds
 ON dc.DimCustomerId = ds.DimCustomerId
 ORDER BY ds.SSB_CRMSYSTEM_PRIMARY_FLAG DESC
 */





GO
