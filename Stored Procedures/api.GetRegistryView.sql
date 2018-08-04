SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [api].[GetRegistryView]
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
SELECT  CASE WHEN @SSB_CRMSYSTEM_ACCT_ID NOT IN ('None', 'Test') THEN @SSB_CRMSYSTEM_ACCT_ID
	ELSE @SSB_CRMSYSTEM_CONTACT_ID END AS Source_System_ID ,
        'SSB Composite Record' AS Source_System ,
        FirstName AS First_Name ,
        LastName AS Last_Name,
        MiddleName AS Middle_Name,
        AddressPrimaryStreet  AS Address_Primary_Street,
        AddressPrimarySuite AS Address_Primary_Suite,
        AddressPrimaryCity AS Address_Primary_City,
        AddressPrimaryState AS Address_Primary_State,
        AddressPrimaryZip AS Address_Primary_Zip,
        PhonePrimary AS Phone_Primary,
        EmailPrimary AS Email_Primary,
        CASE WHEN @SSB_CRMSYSTEM_ACCT_ID NOT IN ('None', 'Test') THEN @SSB_CRMSYSTEM_ACCT_ID
	ELSE @SSB_CRMSYSTEM_CONTACT_ID END AS SSB_GUID ,
        0 AS Is_Primary ,
        1 AS Is_Composite ,
        dc.CustomerType AS Customer_Type,
        NULL AS Customer_Matchkey ,
        NULL AS Contact_GUID ,
        dc.SSB_CRMSYSTEM_ACCT_ID ,
        dc.CD_Gender AS Gender ,
        dc.CompanyName AS Company_Name
FROM    mdm.compositerecord dc ( NOLOCK )
WHERE   ContactGUID IN (SELECT GUID FROM @GUIDTable)
UNION
SELECT  SSID AS Source_System_ID ,
        SourceSystem AS Source_System,
        FirstName AS First_Name,
        LastName AS Last_Name,
        MiddleName AS Middle_Name,
        AddressPrimaryStreet AS Address_Primary_Street,
        AddressPrimarySuite AS Address_Primary_Suite,
        AddressPrimaryCity AS Address_Primary_City,
        AddressPrimaryState AS Address_Primary_State,
        AddressPrimaryZip AS Address_Primary_Zip,
        PhonePrimary AS Phone_Primary,
        EmailPrimary AS Email_Primary,
        CASE WHEN @SSB_CRMSYSTEM_ACCT_ID NOT IN ('None', 'Test') THEN @SSB_CRMSYSTEM_ACCT_ID
	ELSE @SSB_CRMSYSTEM_CONTACT_ID END AS SSB_GUID ,
        ds.SSB_CRMSYSTEM_PRIMARY_FLAG AS Is_Primary ,
        0 AS Is_Composite ,
        dc.CustomerType AS Customer_Type ,
        dc.Customer_Matchkey ,
        dc.ContactGUID AS Contact_GUID ,
        SSB_CRMSYSTEM_ACCT_ID ,
        dc.CD_Gender AS Gender ,
        dc.CompanyName AS Company_Name
FROM    DimCustomer dc
        JOIN ( SELECT   DimCustomerId ,
                        SSB_CRMSYSTEM_PRIMARY_FLAG ,
                        SSB_CRMSYSTEM_ACCT_ID
               FROM     dimcustomerssbid  (NOLOCK)
               WHERE    SSB_CRMSYSTEM_CONTACT_ID IN (SELECT GUID FROM @GUIDTable)
             ) ds ON dc.DimCustomerId = ds.DimCustomerId) x

SELECT 
  ISNULL(CAST(Source_System_ID AS VARCHAR(50))					,'')	Source_System_ID
, ISNULL(Source_System,'')	Source_System
, ISNULL(First_Name,'')	First_Name
, ISNULL(Last_Name,'')	Last_Name
, ISNULL(Middle_Name,'')	Middle_Name
, ISNULL(Address_Primary_Street,'')	Address_Primary_Street
, ISNULL(Address_Primary_Suite,'')	Address_Primary_Suite
, ISNULL(Address_Primary_City,'')	Address_Primary_City
, ISNULL(Address_Primary_State,'')	Address_Primary_State
, ISNULL(Address_Primary_Zip,'')	Address_Primary_Zip
, ISNULL(Phone_Primary,'')	Phone_Primary
, ISNULL(Email_Primary,'')	Email_Primary
, ISNULL(CAST(SSB_GUID AS VARCHAR(50)),'')	SSB_GUID
, CASE WHEN ISNULL(Is_Primary,'') = 1 THEN 'Yes' WHEN ISNULL(Is_Primary,'') = 0 THEN 'NO' ELSE NULL END AS 	Is_Primary
, ISNULL(Is_Composite,'')	Is_Composite
, ISNULL(Customer_Type,'')	Customer_Type
, ISNULL(customer_matchkey,'')	Customer_Matchkey
, ISNULL(CAST(Contact_GUID AS VARCHAR(50)),'')  AS Contact_GUID
, ISNULL(CAST(SSB_CRMSYSTEM_ACCT_ID AS VARCHAR(50)),'')	SSB_CRMSYSTEM_ACCT_ID
, ISNULL(Gender, '') AS Gender
, ISNULL(Company_Name,'') AS Company_Name
INTO #tmpOutput
FROM #tmpBase
ORDER BY Last_Name DESC
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
		FOR XML PATH ('Parent'), ROOT('Parents'))

SET @rootNodeName = 'Parents'

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
