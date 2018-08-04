SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE PROCEDURE [api].[GetEmma]
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
        FROM    ( 
					SELECT DISTINCT pc.emma__Emma_Member_ID__c AS Member_ID
						, eg.[Name] Group_Name
						, em.[Name] Mailing_Name
						, ee.[Name] Email_Name
						, em.emma__Email_Subject__c Email_Subject
						, ee.emma__Opened__c Email_Opened
						, ee.emma__Summary_Num_of_Clicks__c Count_Clicks
						, ee.emma__Summary_Num_of_Opens__c Count_Opens
						, ee.emma__Summary_Num_of_Shares__c Count_Shares
						, ee.emma__Summary_Num_of_Forwards__c Count_Forwards
						, pc.emma__Bounced__c AS Bounced
					FROM dbo.dimcustomerssbid ssbid
					JOIN SouthCarolina_Reporting.prodcopy.contact pc ON ssbid.ssid = pc.Id
					JOIN SouthCarolina_Reporting.prodcopy.Emma__Emma_Email__c ee
						ON pc.id = ee.emma__Contact__c
					JOIN SouthCarolina_Reporting.prodcopy.Emma__Emma_Mailing__c em
						ON ee.emma__Emma_Mailing__c = em.ID
					LEFT JOIN (
						SELECT egm.emma__Contact__c, eg.[Name]
						FROM SouthCarolina_Reporting.prodcopy.Emma__Emma_Group_Member__c egm
						JOIN SouthCarolina_Reporting.prodcopy.Emma__Emma_Group__c eg ON egm.emma__Emma_Group__c = eg.Id
						) eg ON pc.id = eg.emma__Contact__c
                  --WHERE     ISNULL([d].[SSB_CRMSYSTEM_ACCT_ID], [d].[SSB_CRMSYSTEM_CONTACT_ID]) IN ( SELECT GUID       --20170321 RJordheim changed where clause to just evaluate ssb_crmsystem_contact_id againg the GUID table since the GUID table is populated with distinct ssb_crmsystem_contact_id regardless of whether or not ssb_crmsystem_acct_id is supplied in the parameters
                  --                                                                                   FROM @GUIDTable ) 
                  WHERE     ssbid.SSB_CRMSYSTEM_CONTACT_ID IN ( SELECT GUID FROM @GUIDTable )


                ) x

        SELECT  ISNULL(Member_ID, '') Member_ID
              , ISNULL(Group_Name, '') Group_Name
              , ISNULL(Mailing_Name, '') Mailing_Name
              , ISNULL(Email_Name, '') Email_Name
              , ISNULL(Email_Subject, '') Email_Subject
              , ISNULL(Email_Opened, '') Email_Opened
              , ISNULL(Count_Clicks, '') Count_Clicks
              , ISNULL(Count_Opens, '') Count_Opens
              , ISNULL(Count_Shares, '') Count_Shares
              , ISNULL(Count_Forwards, '') Count_Forwards
              , ISNULL(Bounced, '') Bounced
        INTO    #tmpOutput
        FROM    #tmpBase
        ORDER BY Member_ID, Group_Name, Mailing_Name, Email_Name
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
