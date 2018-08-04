SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [api].[GetAttendance_OLD]
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
              ArchticsID NVARCHAR(255)
			, SeasonName NVARCHAR(255)
            , EventName DATE
            , EventDateTime DATETIME
            , SectionName NVARCHAR(255)
            , RowName NVARCHAR(255)
            , Seat NVARCHAR(255)
            , ScanDateTime DATETIME
			, ScanGameTimeDiff NVARCHAR(255)
            , ScanGate NVARCHAR(255)
            );

-- =========================================
-- Procedure
-- =========================================


SELECT fa.SSID_acct_id AS ArchticsID
	, ds.SeasonName
	, de.EventName
	, de.EventDateTime
	, st.SectionName
	, st.RowName
	, st.Seat
	, fa.ScanDateTime
	, CONCAT(ABS(DATEDIFF(MINUTE,fa.ScanDateTime, de.EventDateTime)),' minute(s)') AS ScanGameTimeDiff
	, ScanGate
FROM dbo.FactAttendance fa
JOIN dbo.DimEvent de ON fa.DimEventId = de.DimEventId
JOIN dbo.DimSeason ds ON de.DimSeasonId = ds.DimSeasonId
JOIN dbo.DimSeat st ON fa.DimSeatId = st.DimSeatId
JOIN dbo.vwDimCustomer_ModAcctId dc ON fa.DimCustomerId = dc.DimCustomerId
WHERE dc.SSB_CRMSYSTEM_CONTACT_ID = @ContactGUID
ORDER BY fa.SSID_acct_id




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
                             SELECT ISNULL(ArchticsID, '') AS ArchticsID
                                  , ISNULL(SeasonName,'') AS SeasonName
                                  , ISNULL(EventName,'') AS EventName
                                  , ISNULL(EventDateTime,'') AS EventDateTime
                                  , ISNULL(SectionName,'') AS SectionName
                                  , ISNULL(RowName,'') AS RowName
                                  , ISNULL(Seat,'') AS Seat
                                  , ISNULL(ScanDateTime,'') AS ScanDateTime
								  , ISNULL(ScanGameTimeDiff,'') AS ScanGameTimeDiff                          
                                  , ISNULL(ScanGate,'') AS ScanGate                           
                             FROM   @baseData
                           FOR
                             XML PATH('Attendance')
                               , ROOT('Attendances')
                           );

        SET @rootNodeName = 'Attendances';

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
