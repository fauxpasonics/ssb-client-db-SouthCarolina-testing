SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [rpt].[DevelopmentYOYSummary_V1] (@CYSeason NVARCHAR(100))
AS

/*DECLARE @Season NVARCHAR(100) = '2017 Football'
--DECLARE @CY INT = 2017
--DECLARE @PY INT = @CY - 1
DECLARE @CYSeason NVARCHAR(100)
	SET @CYSeason = (SELECT dsh.SeasonCode
					FROM dbo.DimSeasonHeader dsh
					LEFT OUTER JOIN dbo.DimSeasonHeader dsh_p
						ON  dsh.PrevSeasonHeaderId = dsh_p.DimSeasonHeaderId
					WHERE dsh.SeasonName = @Season)*/
DECLARE @PYSeason NVARCHAR(100) = CONCAT(LEFT(@CYSeason,2),RIGHT(@CYSeason,2) - 1)


/*========================================================================
	Pull donation info
========================================================================*/
SELECT d.apply_to_acct_id ArchticsID
	, d.fund_name FundName
	, CASE WHEN d.fund_name LIKE 'GC%' THEN 'GC'
		WHEN d.fund_name LIKE 'SGC%' THEN 'SGC'
		WHEN d.fund_name LIKE 'JR%' THEN 'JR'
		WHEN d.fund_name LIKE 'LFPY%' THEN 'LFPY'
		ELSE NULL END AS FundAbbreviation
	, drive_year DriveYear
	, SUM(pledge_amount) Donation
INTO #Donations
FROM ods.TM_Donation d
GROUP BY d.apply_to_acct_id
		, d.fund_name
		, CASE WHEN d.fund_name LIKE 'GC%' THEN 'GC'
 			WHEN d.fund_name LIKE 'SGC%' THEN 'SGC'
 			WHEN d.fund_name LIKE 'JR%' THEN 'JR'
 			WHEN d.fund_name LIKE 'LFPY%' THEN 'LFPY'
 			ELSE NULL END
		, d.drive_year

CREATE NONCLUSTERED INDEX IDX_ArchticsID ON #Donations (ArchticsID)
CREATE NONCLUSTERED INDEX IDX_FundName ON #Donations (FundName)


/*========================================================================
	Aggregate donors with season ticket purchase info
========================================================================*/

SELECT funds.ID
	, funds.FundType
	, funds.FundName GivingLevel
	, SUM(CASE WHEN sth.PlanCode = @CYSeason THEN 1 END) AS CYNumAccounts
	, SUM(CASE WHEN sth.PlanCode = @PYSeason THEN 1 END) AS PYNumAccounts
	, SUM(CASE WHEN sth.PlanCode = @CYSeason THEN sth.Tickets END) AS CYTickets
	, SUM(CASE WHEN sth.PlanCode = @PYSeason THEN sth.Tickets END) AS PYTickets
INTO #Tickets
FROM rpt.GCFundLevels Funds
LEFT JOIN #Donations don
	ON funds.FundAbbreviation = don.FundAbbreviation
	AND (don.Donation BETWEEN funds.MinDonation AND funds.MaxDonation)
LEFT JOIN rpt.vw_DonorSeasonTicketsBySportSeason sth
	ON don.ArchticsID = sth.ArchticsID
	AND RIGHT(don.DriveYear,2) = RIGHT(sth.PlanCode,2)
GROUP BY funds.ID, Funds.FundType, Funds.FundName

CREATE NONCLUSTERED INDEX IDX_FundType ON #Tickets (FundType)
CREATE NONCLUSTERED INDEX IDX_GivingLevel ON #Tickets (GivingLevel)


/*========================================================================
	Calculate Delta
========================================================================*/

SELECT FundType
	, GivingLevel
	, ISNULL(PYTickets,0) PYTickets
	, ISNULL(PYNumAccounts,0) PYNumAccounts
	, ISNULL(CYTickets,0) CYTickets
	, ISNULL(CYNumAccounts,0) CYNumAccounts
	, (ISNULL(PYTickets,0) - ISNULL(CYTickets,0)) AS TicketDifference
	, (ISNULL(PYNumAccounts,0) - ISNULL(CYNumAccounts,0)) AS MembershipDifference
FROM #Tickets
ORDER BY ID




GO
