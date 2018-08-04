SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE PROCEDURE [api].[GetTransactions]
    @SSB_CRMSYSTEM_ACCT_ID VARCHAR(50) = 'Test'
  , @SSB_CRMSYSTEM_CONTACT_ID VARCHAR(50) = 'Test'
  , @DisplayTable INT = 0
  , @RowsPerPage INT = 500
  , @PageNumber INT = 0
AS
    BEGIN 

-- Init vars needed for API
        DECLARE @totalCount INT
          , @xmlDataNode XML
          , @recordsInResponse INT
          , @remainingCount INT
          , @rootNodeName NVARCHAR(100)
          , @responseInfoNode NVARCHAR(MAX)
          , @finalXml XML


        --DECLARE @SSB_CRMSYSTEM_ACCT_ID VARCHAR(50) = 'None'
        --DECLARE @SSB_CRMSYSTEM_CONTACT_ID VARCHAR(50) = '0C75AE2F-56D7-4391-8917-07D635431312'
        --DECLARE @RowsPerPage INT = 500
        --  , @PageNumber INT = 0
        --DECLARE @DisplayTable INT = 0


        PRINT 'Acct-' + @SSB_CRMSYSTEM_ACCT_ID
        PRINT 'Contact-' + @SSB_CRMSYSTEM_CONTACT_ID

        DECLARE @GUIDTable TABLE ( GUID VARCHAR(50) )

        IF ( @SSB_CRMSYSTEM_ACCT_ID NOT IN ( 'None', 'Test' ) )
            BEGIN
                INSERT  INTO @GUIDTable
                        ( GUID
                        )
                        SELECT DISTINCT
                                z.SSB_CRMSYSTEM_CONTACT_ID
                        FROM    dbo.vwDimCustomer_ModAcctId z
                        WHERE   z.SSB_CRMSYSTEM_ACCT_ID = @SSB_CRMSYSTEM_ACCT_ID
            END

        IF ( @SSB_CRMSYSTEM_CONTACT_ID NOT IN ( 'None', 'Test' ) )
            BEGIN
                INSERT  INTO @GUIDTable
                        ( GUID
                        )
                        SELECT  @SSB_CRMSYSTEM_CONTACT_ID
            END



        SELECT  *
        INTO    #tmpBase
        FROM    ( SELECT DISTINCT
                            'Gamecocks' AS Team
                          , fts.SSID_acct_id AS Ticket_ID
                          , ds.SeasonName AS Season_Name
                          , de.EventName AS Event_Name
                          , CAST(fts.OrderNum AS NVARCHAR(100)) AS Order_Number
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
                          , CAST(fts.PcPrice AS nvarchar(100)) AS Seat_Price
                          , CAST(fts.BlockPurchasePrice AS nvarchar(100)) AS Block_Purchase_Price
                          , CAST(fts.OwedAmount AS nvarchar(100)) AS Owed_Amount
                          , CAST(fts.PaidAmount AS nvarchar(100)) AS Paid_Amount
                          , CAST(fts.SSCreatedBy AS nvarchar(100)) AS Sales_Rep
                  FROM      dbo.FactTicketSales AS fts WITH (NOLOCK)
                            JOIN dbo.dimcustomerssbid AS d WITH (NOLOCK) ON d.DimCustomerId = fts.DimCustomerId
                            JOIN dbo.DimSeason AS ds WITH (NOLOCK) ON ds.DimSeasonId = fts.DimSeasonId
                            JOIN dbo.DimItem AS di WITH (NOLOCK) ON di.DimItemId = fts.DimItemId
                            JOIN dbo.DimPriceCode AS dpc WITH (NOLOCK) ON dpc.DimPriceCodeId = fts.DimPriceCodeId
                            JOIN dbo.DimPlan AS dp WITH (NOLOCK) ON dp.DimPlanId = fts.DimPlanId
                            JOIN dbo.DimDate AS dd WITH (NOLOCK) ON dd.DimDateId = fts.DimDateId
                            JOIN dbo.DimEvent AS de WITH (NOLOCK) ON de.DimEventId = fts.DimEventId
                            JOIN dbo.DimPromo AS dp2 WITH (NOLOCK) ON dp2.DimPromoID = fts.DimPromoId
                            JOIN dbo.DimSeat AS ds2 WITH (NOLOCK) ON ds2.DimSeatId = fts.DimSeatIdStart
                  --WHERE     ISNULL([d].[SSB_CRMSYSTEM_ACCT_ID], [d].[SSB_CRMSYSTEM_CONTACT_ID]) IN ( SELECT GUID       --20170321 RJordheim changed where clause to just evaluate ssb_crmsystem_contact_id againg the GUID table since the GUID table is populated with distinct ssb_crmsystem_contact_id regardless of whether or not ssb_crmsystem_acct_id is supplied in the parameters
                  --                                                                                   FROM @GUIDTable ) 
                  WHERE     d.SSB_CRMSYSTEM_CONTACT_ID IN ( SELECT GUID FROM @GUIDTable )

				UNION ALL

				SELECT DISTINCT
					'CLA' AS Team
					, trans.CUSTOMER AS Ticket_ID
					, SEASON.NAME COLLATE SQL_Latin1_General_CP1_CS_AS AS Season_Name
					, item.NAME COLLATE SQL_Latin1_General_CP1_CS_AS AS Event_Name
					, trans.ZID COLLATE SQL_Latin1_General_CP1_CS_AS AS Order_Number
					, NULL AS Order_Line
					, CAST(trans.I_DATE AS DATE) AS Order_Date
					, trans.Item COLLATE SQL_Latin1_General_CP1_CS_AS AS Item
					, item.NAME COLLATE SQL_Latin1_General_CP1_CS_AS AS Item_Name
					, NULL AS Event_Date
					, trans.I_PT COLLATE SQL_Latin1_General_CP1_CS_AS AS Price_Code
					, NULL AS Is_Comp
					, NULL AS Promo_Code
					, trans.I_OQTY AS Qty
					, NULL AS Section_Name
					, NULL AS Row_Name
					, NULL AS Seat_Block
					, CAST(trans.I_Price AS nvarchar(100)) AS Seat_Price
					, CAST(trans.I_PAY AS nvarchar(100)) AS Block_Purchase_Price
					, CAST(NULL AS nvarchar(100)) AS Owed_Amount
					, CAST(trans.I_PAY AS nvarchar(100)) AS Paid_Amount
					, CAST(NULL AS nvarchar(100)) AS Sales_Rep
				FROM dbo.TK_ODET trans WITH (NOLOCK)
				JOIN dbo.DimCustomerSSBID ssbid WITH (NOLOCK) ON ssbid.SourceSystem = 'PAC_CLA' AND ssbid.ssid = trans.CUSTOMER
				LEFT JOIN  TK_SEASON season WITH (NOLOCK) ON trans.season = season.season
				LEFT JOIN  TK_ITEM item WITH (NOLOCK) ON trans.Item = item.ITEM AND trans.Season = item.SEASON
				WHERE     ssbid.SSB_CRMSYSTEM_CONTACT_ID IN ( SELECT GUID FROM @GUIDTable )
				AND trans.SEASON LIKE 'CC%'


                ) x

        SELECT  ISNULL(Team, '') Team
              , ISNULL(Ticket_ID, '') Ticket_ID
              , ISNULL(Season_Name, '') Season_Name
              , ISNULL(Event_Name, '') Event_Name
              , ISNULL(Order_Number, '') Order_Number
              , ISNULL(Order_Line, '') Order_Line_Item
              , ISNULL(Order_Date, '') Order_Date
              , ISNULL(Item, '') Item
              , ISNULL(Item_Name, '') Item_Name
              , ISNULL(Event_Date, '') Event_Date
              , ISNULL(Price_Code, '') Price_code
              , ISNULL(Is_Comp, '') Is_Comp
              , ISNULL(Promo_Code, '') Promo_Code
              , ISNULL(Qty, '') Qty
              , ISNULL(Section_Name, '') Section_Name
              , ISNULL(Row_Name, '') Row_Name
              , ISNULL(Seat_Block, '') Seat_Block
              , ISNULL(Seat_Price, '') Seat_Price
              , ISNULL(Block_Purchase_Price, '') Block_Purchase_Price
              , ISNULL(Owed_Amount, '') Owed_Amount
              , ISNULL(Paid_Amount, '') Paid_Amount
              , ISNULL(Sales_Rep, '') Sales_Rep
        INTO    #tmpOutput
        FROM    #tmpBase
        ORDER BY Event_Date DESC
              , Order_Date 
              OFFSET ( @PageNumber ) * @RowsPerPage ROWS
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
        SELECT  @recordsInResponse = COUNT(*)
        FROM    #tmpOutput
        SELECT  @totalCount = COUNT(*)
        FROM    #tmpBase

        SET @xmlDataNode = ( SELECT * FROM #tmpOutput
                           FOR
                             XML PATH('Parent')
                               , ROOT('Parents')
                           )

        SET @rootNodeName = 'Parents'

-- Calculate remaining count
        SET @remainingCount = @totalCount - ( @RowsPerPage * ( @PageNumber + 1 ) )
        IF @remainingCount < 0
            BEGIN
                SET @remainingCount = 0
            END

-- Create response info node
        SET @responseInfoNode = ( '<ResponseInfo>' + '<TotalCount>' + CAST(@totalCount AS NVARCHAR(20))
                                  + '</TotalCount>' + '<RemainingCount>' + CAST(@remainingCount AS NVARCHAR(20))
                                  + '</RemainingCount>' + '<RecordsInResponse>'
                                  + CAST(@recordsInResponse AS NVARCHAR(20)) + '</RecordsInResponse>'
                                  + '<PagedResponse>true</PagedResponse>' + '<RowsPerPage>'
                                  + CAST(@RowsPerPage AS NVARCHAR(20)) + '</RowsPerPage>' + '<PageNumber>'
                                  + CAST(@PageNumber AS NVARCHAR(20)) + '</PageNumber>' + '<RootNodeName>'
                                  + @rootNodeName + '</RootNodeName>' + '</ResponseInfo>' )

        PRINT @responseInfoNode
	
-- Wrap response info and data, then return	
        IF @xmlDataNode IS NULL
            BEGIN
                SET @xmlDataNode = '<' + @rootNodeName + ' />' 
            END
		
        SET @finalXml = '<Root>' + @responseInfoNode + CAST(@xmlDataNode AS NVARCHAR(MAX)) + '</Root>'

        IF @DisplayTable = 1
            SELECT  *
            FROM    #tmpBase

        IF @DisplayTable = 0
            SELECT  CAST(@finalXml AS XML)

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
