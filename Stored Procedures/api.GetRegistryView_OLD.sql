SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [api].[GetRegistryView_OLD]
    (
      @ContactGUID VARCHAR(50)
    , @RowsPerPage INT = 500
    , --APIification
      @PageNumber INT = 0 --APIification
    )
AS
    BEGIN

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

-- =========================================
-- Base Table Set
-- =========================================


        DECLARE @baseData TABLE
            (
              SourceDB NVARCHAR(255)
			, SourceSystem NVARCHAR(255)
            , AccountID DATE
            , SSID NVARCHAR(255)
            , WinningRecord NVARCHAR(255)
            , Prefix NVARCHAR(255)
            , FirstName NVARCHAR(255)
            , MiddleName NVARCHAR(255)
			, LastName NVARCHAR(255)
            , Suffix NVARCHAR(255)
            , AddressPrimaryStreet NVARCHAR(255)
            , AddressPrimaryCity NVARCHAR(255)
            , AddressPrimaryState NVARCHAR(255)
			, AddressPrimaryCounty NVARCHAR(255)
            , AddressPrimaryCountry NVARCHAR(255)
			, PhonePrimary NVARCHAR(255)
            , EmailPrimary NVARCHAR(255)
			, AddressPrimaryNCOAStatus NVARCHAR(255)
            , CustomerMatchkey NVARCHAR(255)
            , UpdatedDate DATE
            );

-- =========================================
-- Procedure
-- =========================================


SELECT DISTINCT
	SourceDB
	, SourceSystem
	, AccountID
	, SSID
	, SSB_CRMSYSTEM_PRIMARY_FLAG AS WinningRecord
	, Prefix
	, FirstName
	, MiddleName
	, LastName
	, Suffix
	, AddressPrimaryStreet
	, AddressPrimaryCity
	, AddressPrimaryState
	, AddressPrimaryZip
	, AddressPrimaryCounty
	, AddressPrimaryCountry
	, PhonePrimary
	, EmailPrimary
	, AddressPrimaryNCOAStatus
	, customer_matchkey AS CustomerMatchkey
	, SSUpdatedDate AS UpdatedDate
FROM dbo.vwDimCustomer_ModAcctId
WHERE SSB_CRMSYSTEM_CONTACT_ID = @ContactGUID;




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
                ORDER BY c.OrderDate DESC
                      , c.OrderNumber
                      OFFSET ( @PageNumber ) * @RowsPerPage ROWS

FETCH NEXT @RowsPerPage ROWS ONLY;

-- Set records in response

        SELECT  @recordsInResponse = COUNT(*)
        FROM    @baseData;
-- Create XML response data node

        SET @xmlDataNode = (
                             SELECT ISNULL(SourceDB, '') AS SourceDB
                                 
                                  , ISNULL(SourceSystem,'') AS SourceSystem
                                  , ISNULL(AccountID,'') AS AccountID
                                  , ISNULL(SSID,'') AS SSID
                                  , ISNULL(WinningRecord,'') AS WinningRecord
                                  , ISNULL(Prefix,'') AS Prefix
                                  , ISNULL(FirstName,'') AS FirstName
                                  , ISNULL(MiddleName,'') AS MiddleName
								  , ISNULL(LastName,'') AS LastName                                
                                  , ISNULL(Suffix,'') AS Suffix                              
                                  , ISNULL(AddressPrimaryStreet,'') AS AddressPrimaryStreet
                                  , ISNULL(AddressPrimaryCity,'') AS AddressPrimaryCity
                                  , ISNULL(AddressPrimaryState,'') AS AddressPrimaryState
                                  , ISNULL(AddressPrimaryCounty,'') AS AddressPrimaryCounty
								  , ISNULL(AddressPrimaryCountry,'') AS AddressPrimaryCountry
								  , ISNULL(PhonePrimary,'') AS PhonePrimary
                                  , ISNULL(EmailPrimary,'') AS EmailPrimary
								  , ISNULL(AddressPrimaryNCOAStatus,'') AS AddressPrimaryNCOAStatus
								  , ISNULL(CustomerMatchkey,'') AS CustomerMatchkey
								  , ISNULL(UpdatedDate, '') AS UpdatedDate
                             FROM   @baseData
                           FOR
                             XML PATH('Customer')
                               , ROOT('Customers')
                           );

        SET @rootNodeName = 'Customers';

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
