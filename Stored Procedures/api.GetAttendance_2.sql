SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [api].[GetAttendance_2]
    (
    @SSB_CRMSYSTEM_ACCT_ID VARCHAR(50) = 'Test',
	@SSB_CRMSYSTEM_CONTACT_ID VARCHAR(50) = 'Test',
	@DisplayTable INT = 0, --APIification
    @RowsPerPage  INT = 500, @PageNumber INT = 0 --APIification
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
              Archtics_ID NVARCHAR(255)
			, Season_Name NVARCHAR(255)
            , Event_Name NVARCHAR(255)
            , Event_Date_Time DATETIME
            , Section_Name NVARCHAR(255)
            , Row_Name NVARCHAR(255)
            , Seat NVARCHAR(255)
            , Scan_Date_Time DATETIME
			, Scan_Game_Time_Diff NVARCHAR(255)
            , Scan_Gate NVARCHAR(255)
            );

-- =========================================
-- Procedure
-- =========================================


SELECT fa.SSID_acct_id AS ArchticsID
	, ds.SeasonName AS Season_Name
	, de.EventName AS Event_Name
	, de.EventDateTime AS Event_Date_Time
	, st.SectionName Section_Name
	, st.RowName AS Row_Name
	, st.Seat Seat
	, fa.ScanDateTime AS Scan_Date_Time
	, CONCAT(ABS(DATEDIFF(MINUTE,fa.ScanDateTime, de.EventDateTime)),' minute(s)') AS Scan_Game_Tim_eDiff
	, ScanGate AS Scan_Gate
	INTO #Trans
FROM dbo.FactAttendance fa
JOIN dbo.DimEvent de ON fa.DimEventId = de.DimEventId
JOIN dbo.DimSeason ds ON de.DimSeasonId = ds.DimSeasonId
JOIN dbo.DimSeat st ON fa.DimSeatId = st.DimSeatId
JOIN dbo.vwDimCustomer_ModAcctId dc ON fa.DimCustomerId = dc.DimCustomerId
WHERE ISNULL([dc].[SSB_CRMSYSTEM_ACCT_ID],dc.[SSB_CRMSYSTEM_CONTACT_ID]) IN (SELECT GUID FROM @GUIDTable)
ORDER BY fa.SSID_acct_id;




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
                ORDER BY c.Event_Date_Time DESC
                      OFFSET ( @PageNumber ) * @RowsPerPage ROWS

FETCH NEXT @RowsPerPage ROWS ONLY;

-- Set records in response

        SELECT  @recordsInResponse = COUNT(*)
        FROM    @baseData;
-- Create XML response data node

        SET @xmlDataNode = (
                             SELECT ISNULL(Archtics_ID, '') AS Archtics_ID
                                  , ISNULL(Season_Name,'') AS Season_Name
                                  , ISNULL(Event_Name,'') AS Event_Name
                                  , ISNULL(Event_Date_Time,'') AS Event_Date_Time
                                  , ISNULL(Section_Name,'') AS Section_Name
                                  , ISNULL(Row_Name,'') AS Row_Name
                                  , ISNULL(Seat,'') AS Seat
                                  , ISNULL(Scan_Date_Time,'') AS Scan_Date_Time
								  , ISNULL(Scan_Game_Time_Diff,'') AS Scan_Game_Time_Diff                          
                                  , ISNULL(Scan_Gate,'') AS Scan_Gate                           
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
