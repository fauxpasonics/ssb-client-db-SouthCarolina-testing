SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [api].[GetContactDonations_OLD]
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
              Team NVARCHAR(255)
			   , Account NVARCHAR(255)
            , PledgeDate DATE
            , OrderNumber NVARCHAR(255)
            , OrderLineItem NVARCHAR(255)
            , DonationType NVARCHAR(255)
            , FundName NVARCHAR(255)
            , FundDescription NVARCHAR(255)
			, DriveYear NVARCHAR(255)
            , GLCode NVARCHAR(255)
            , SolicitationName NVARCHAR(255)
            , SolicitationCategory NVARCHAR(255)
            , ContactType NVARCHAR(255)
			, OriginalPledgeAmount DECIMAL(15,4)
            , PledgeAmount DECIMAL(15,4)
			, TotalReceivedAmount DECIMAL(15,4)
            , OwedAmount DECIMAL(15,4)
			, ExternalPaidAmount DECIMAL(15,4)
            , DonorLevelAmountQual DECIMAL(15,4)
            , DonorLevelAmountNotQual DECIMAL(15,4)
			, DonationSource NVARCHAR(255)
			, Points DECIMAL(15,4)
			, DonorLevelSet NVARCHAR(255)
            );

-- =========================================
-- Procedure
-- =========================================


SELECT DISTINCT
	'Gamecocks' AS Team
	, don.acct_id AS Account
	, CAST(don.pledge_datetime AS DATE) AS PledgeDate
	, don.order_num AS OrderNumber
	, don.order_line_item AS OrderLineItem
	, don.donation_type_name AS DonationType
	, don.fund_name AS FundName
	, don.fund_desc AS FundDescription
	, don.drive_year AS DriveYear
	, don.gl_code AS GLCode
	, don.solicitation_name AS SolicitationName
	, don.solicitation_category_name AS SolicitationCategory
	, don.contact_type AS ContactType
	, don.original_pledge_amount AS OriginalPledgeAmount
	, don.pledge_amount AS PledgeAmount
	, don.total_received_amount AS TotalReceivedAmount
	, don.owed_amount AS OwedAmount
	, don.external_paid_amount AS ExternalPaidAmount
	, don.donor_level_amount_qual AS DonorLevelAmountQual
	, don.donor_level_amount_not_qual AS DonorLevelAmountNotQual
	, don.[source] AS DonationSource
	, don.points AS Points
	, don.donor_level_set_name AS DonorLevelSet
FROM ods.TM_Donation don
JOIN dbo.vwDimCustomer_ModAcctId dc ON don.acct_id = dc.AccountId
WHERE dc.SSB_CRMSYSTEM_CONTACT_ID = @ContactGUID;



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
                             SELECT ISNULL(Team, '') AS Team
                                 
                                  , ISNULL(Account,'') AS Account
                                  , ISNULL(PledgeDate,'') AS PledgeDate
                                  , ISNULL(OrderNumber,'') AS OrderNumber
                                  , ISNULL(OrderLineItem,'') AS OrderLineItem
                                  , ISNULL(DonationType,'') AS DonationType
                                  , ISNULL(FundName,'') AS FundName
                                  , ISNULL(FundDescription,'') AS FundDescription
								  , ISNULL(DriveYear,'') AS DriveYear                                 
                                  , ISNULL(GLCode,'') AS GLCode                               
                                  , ISNULL(SolicitationName,'') AS SolicitationName
                                  , ISNULL(SolicitationCategory,'') AS SolicitationCategory
                                  , ISNULL(ContactType,'') AS ContactType
                                  , ISNULL(OriginalPledgeAmount,0) AS OriginalPledgeAmount
								  , ISNULL(PledgeAmount,0) AS PledgeAmount
								  , ISNULL(TotalReceivedAmount,0) AS TotalReceivedAmount
                                  , ISNULL(OwedAmount,0) AS OwedAmount
								  , ISNULL(ExternalPaidAmount,0) AS ExternalPaidAmount
								  , ISNULL(DonorLevelAmountQual,0) AS DonorLevelAmountQual
								  , ISNULL(DonorLevelAmountNotQual, 0) AS DonorLevelAmountNotQual
								  , ISNULL(DonationSource,0) AS DonationSource
								  , ISNULL(Points,0) AS Points
								  , ISNULL(DonorLevelSet,'') AS DonorLevelSet
                             FROM   @baseData
                           FOR
                             XML PATH('Donation')
                               , ROOT('Donations')
                           );

        SET @rootNodeName = 'Donations';

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
