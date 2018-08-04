SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [api].[GetContactDonations] 
    (
      @SSB_CRMSYSTEM_ACCT_ID VARCHAR(50) = 'Test',
	@SSB_CRMSYSTEM_CONTACT_ID VARCHAR(50) = 'Test',
	@DisplayTable INT = 0,
	@RowsPerPage  INT = 500, @PageNumber   INT = 0
    )
AS
    BEGIN

--DECLARE @SSB_CRMSYSTEM_ACCT_ID VARCHAR(50) = 'D7BEF141-C476-4709-BBF2-97BADD986E3D'
--DECLARE @SSB_CRMSYSTEM_CONTACT_ID VARCHAR(50) = 'Test'
--DECLARE	@RowsPerPage  INT = 500, @PageNumber   INT = 0
--DECLARE @DisplayTable INT = 0

--DROP TABLE #Trans
-- =========================================
-- Initial Variables for API
-- =========================================

        DECLARE @totalCount INT
          , @xmlDataNode XML
          , @recordsInResponse INT
          , @remainingCount INT
          , @rootNodeName NVARCHAR(100)
          , @responseInfoNode NVARCHAR(MAX)
          , @finalXml XML;

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
-- =========================================
-- Base Table Set
-- =========================================


        DECLARE @baseData TABLE
            (
              Team NVARCHAR(255)
			   , Account NVARCHAR(255)
            , Pledge_Date DATE
            , Order_Number NVARCHAR(255)
            , Order_Line_Item NVARCHAR(255)
            , Donation_Type NVARCHAR(255)
            , Fund_Name NVARCHAR(255)
            , Fund_Description NVARCHAR(255)
			, Drive_Year NVARCHAR(255)
            , GL_Code NVARCHAR(255)
            , Solicitation_Name NVARCHAR(255)
            , Solicitation_Category NVARCHAR(255)
            , Contact_Type NVARCHAR(255)
			, Original_Pledge_Amount DECIMAL(15,4)
            , Pledge_Amount DECIMAL(15,4)
			, Total_Received_Amount DECIMAL(15,4)
            , Owed_Amount DECIMAL(15,4)
			, External_Paid_Amount DECIMAL(15,4)
            , Donor_Level_Amount_Qual DECIMAL(15,4)
            , Donor_Level_Amount_Not_Qual DECIMAL(15,4)
			, Donation_Source NVARCHAR(255)
			, Points DECIMAL(15,4)
			, Donor_Level_Set NVARCHAR(255)
            );

-- =========================================
-- Procedure
-- =========================================


SELECT DISTINCT
	'Gamecocks' AS Team
	, don.acct_id AS Account
	, CAST(don.pledge_datetime AS DATE) AS Pledge_Date
	, don.order_num AS Order_Number
	, don.order_line_item AS Order_Line_Item
	, don.donation_type_name AS Donation_Type
	, don.fund_name AS Fund_Name
	, don.fund_desc AS Fund_Description
	, don.drive_year AS Drive_Year
	, don.gl_code AS GL_Code
	, don.solicitation_name AS Solicitation_Name
	, don.solicitation_category_name AS Solicitation_Category
	, don.contact_type AS Contact_Type
	, don.original_pledge_amount AS Original_Pledge_Amount
	, don.pledge_amount AS Pledge_Amount
	, don.total_received_amount AS Total_Received_Amount
	, don.owed_amount AS Owed_Amount
	, don.external_paid_amount AS External_Paid_Amount
	, don.donor_level_amount_qual AS Donor_Level_Amount_Qual
	, don.donor_level_amount_not_qual AS Donor_Level_Amount_Not_Qual
	, don.[source] AS Donation_Source
	, don.points AS Points
	, don.donor_level_set_name AS Donor_Level_Set
INTO #Trans
FROM ods.TM_Donation don
JOIN dbo.vwDimCustomer_ModAcctId dc ON don.acct_id = dc.AccountId
--WHERE ISNULL([dc].[SSB_CRMSYSTEM_ACCT_ID],dc.[SSB_CRMSYSTEM_CONTACT_ID]) IN (SELECT GUID FROM @GUIDTable);

WHERE     dc.SSB_CRMSYSTEM_CONTACT_ID IN ( SELECT  GUID
                                                            FROM    @GUIDTable )

-- =========================================
-- API Pagination
-- =========================================
-- Cap returned results at 1000

        IF @RowsPerPage > 1000
            BEGIN

                SET @RowsPerPage = 1000;

            END;

-- Pull total count

        SELECT  @totalCount = COUNT(*)
        FROM    #Trans AS c;

-- =========================================
-- API Loading
-- =========================================

-- Load base data

        INSERT  INTO @baseData
                SELECT  *
                FROM    #Trans AS c
                ORDER BY c.Pledge_Date DESC
                      , c.Order_Number
                      OFFSET ( @PageNumber ) * @RowsPerPage ROWS

FETCH NEXT @RowsPerPage ROWS ONLY;

-- Set records in response

        SELECT  @recordsInResponse = COUNT(*)
        FROM    @baseData;
-- Create XML response data node

        SET @xmlDataNode = (
                             SELECT ISNULL(Team, '') AS Team
                                 
                                  , ISNULL(Account,'') AS Account
                                  , ISNULL(Pledge_Date,'') AS Pledge_Date
                                  , ISNULL(Order_Number,'') AS Order_Number
                                  , ISNULL(Order_Line_Item,'') AS Order_Line_Item
                                  , ISNULL(Donation_Type,'') AS Donation_Type
                                  , ISNULL(Fund_Name,'') AS Fund_Name
                                  , ISNULL(Fund_Description,'') AS Fund_Description
								  , ISNULL(Drive_Year,'') AS Drive_Year                                 
                                  , ISNULL(GL_Code,'') AS GL_Code                               
                                  , ISNULL(Solicitation_Name,'') AS Solicitation_Name
                                  , ISNULL(Solicitation_Category,'') AS Solicitation_Category
                                  , ISNULL(Contact_Type,'') AS Contact_Type
                                  , ISNULL(Original_Pledge_Amount,0) AS Original_Pledge_Amount
								  , ISNULL(Pledge_Amount,0) AS Pledge_Amount
								  , ISNULL(Total_Received_Amount,0) AS Total_Received_Amount
                                  , ISNULL(Owed_Amount,0) AS Owed_Amount
								  , ISNULL(External_Paid_Amount,0) AS External_Paid_Amount
								  , ISNULL(Donor_Level_Amount_Qual,0) AS Donor_Level_Amount_Qual
								  , ISNULL(Donor_Level_Amount_Not_Qual, 0) AS Donor_Level_Amount_Not_Qual
								  , ISNULL(Donation_Source,0) AS Donation_Source
								  , ISNULL(Points,0) AS Points
								  , ISNULL(Donor_Level_Set,'') AS Donor_Level_Set
                             FROM   @baseData
                           FOR
                             XML PATH('Record')
                               , ROOT('Records')
                           );

        SET @rootNodeName = 'Records';

		-- Calculate remaining count

        SET @remainingCount = @totalCount - ( @RowsPerPage * ( @PageNumber + 1 ) );

        IF @remainingCount < 0
            BEGIN

                SET @remainingCount = 0;

            END;

			-- Create response info node

        SET @responseInfoNode = ( '<ResponseInfo>' + '<TotalCount>'
                                  + CAST(@totalCount AS NVARCHAR(20))
                                  + '</TotalCount>' + '<RemainingCount>'
                                  + CAST(@remainingCount AS NVARCHAR(20))
                                  + '</RemainingCount>'
                                  + '<RecordsInResponse>'
                                  + CAST(@recordsInResponse AS NVARCHAR(20))
                                  + '</RecordsInResponse>'
                                  + '<PagedResponse>true</PagedResponse>'
                                  + '<RowsPerPage>'
                                  + CAST(@RowsPerPage AS NVARCHAR(20))
                                  + '</RowsPerPage>' + '<PageNumber>'
                                  + CAST(@PageNumber AS NVARCHAR(20))
                                  + '</PageNumber>' + '<RootNodeName>'
                                  + @rootNodeName + '</RootNodeName>'
                                  + '</ResponseInfo>' );
    END;

-- Wrap response info and data, then return    

    IF @xmlDataNode IS NULL
        BEGIN

            SET @xmlDataNode = '<' + @rootNodeName + ' />';

        END;

    SET @finalXml = '<Root>' + @responseInfoNode
        + CAST(@xmlDataNode AS NVARCHAR(MAX)) + '</Root>';

    SELECT  CAST(@finalXml AS XML);








GO
