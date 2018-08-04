SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [rpt].[DevelopmentYOYSummary_V2] (@CYSeason NVARCHAR(100))
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
SELECT DISTINCT apply_to_acct_id ArchticsID, fund_name FundName, 'CAR' FundAbbreviation, drive_year DriveYear
INTO #CarDealers
FROM ods.TM_Donation
WHERE fund_name LIKE 'CAR%'



SELECT DISTINCT d.apply_to_acct_id ArchticsID
	, d.fund_name FundName
	, CASE WHEN d.fund_name LIKE 'GC%' THEN 'GC'
		WHEN d.fund_name LIKE 'SGC%' THEN 'SGC'
		WHEN d.fund_name LIKE 'JR%' THEN 'JR'
		WHEN d.fund_name LIKE 'LFPY%' THEN 'LFPY'
		END AS FundAbbreviation
	, d.drive_year DriveYear
INTO #NonCarDealers
FROM ods.TM_Donation d
LEFT JOIN #CarDealers c
	ON d.apply_to_acct_id = c.ArchticsID
	AND d.drive_year = c.DriveYear
WHERE c.ArchticsID IS NULL
AND CASE WHEN d.fund_name LIKE 'GC%' THEN 'GC'
		WHEN d.fund_name LIKE 'SGC%' THEN 'SGC'
		WHEN d.fund_name LIKE 'JR%' THEN 'JR'
		WHEN d.fund_name LIKE 'LFPY%' THEN 'LFPY'
		END IS NOT NULL
ORDER BY d.fund_name

CREATE NONCLUSTERED INDEX IDX_ArchticsID ON #NonCarDealers (ArchticsID)
CREATE NONCLUSTERED INDEX IDX_FundName ON #NonCarDealers (FundName)



SELECT c.ArchticsID, c.FundName, c.FundAbbreviation, c.DriveYear
INTO #DonorType
FROM #CarDealers c
UNION
SELECT n.ArchticsID, n.FundName, n.FundAbbreviation, n.DriveYear
FROM #NonCarDealers n

CREATE NONCLUSTERED INDEX IDX_ArchticsID ON #DonorType (ArchticsID)
CREATE NONCLUSTERED INDEX IDX_FundName ON #DonorType (FundName)



SELECT apply_to_acct_id ArchticsID, drive_year DriveYear, SUM(pledge_amount) Donation
INTO #Donations
FROM ods.TM_Donation
GROUP BY apply_to_acct_id, drive_year


SELECT dt.ArchticsID, dt.FundName, dt.FundAbbreviation, dt.DriveYear, SUM(d.Donation) Donation
INTO #DonorSummary
FROM #DonorType dt
JOIN #Donations d
	ON dt.ArchticsID = d.ArchticsID
	AND dt.DriveYear = d.DriveYear
GROUP BY dt.ArchticsID, dt.FundName, dt.FundAbbreviation, dt.DriveYear

CREATE NONCLUSTERED INDEX IDX_ArchticsID ON #DonorSummary (ArchticsID)
CREATE NONCLUSTERED INDEX IDX_FundName ON #DonorSummary (FundName)



SELECT don.ArchticsID, don.DriveYear, don.Donation, don.FundName, don.FundAbbreviation
	, CASE WHEN don.FundAbbreviation = 'CAR' THEN 'Car Dealer' ELSE funds.FundName END AS GivingLevel
	, funds.MinDonation, funds.MaxDonation
INTO #GivingLevels
FROM #DonorSummary don
LEFT JOIN rpt.GCFundLevels funds
	ON funds.FundAbbreviation = don.FundAbbreviation
	AND (don.Donation BETWEEN funds.MinDonation AND funds.MaxDonation)
JOIN dbo.DimCustomer dc
	ON don.ArchticsID = dc.AccountId
	AND dc.SourceSystem = 'TM'
	AND dc.CustomerType = 'Primary'
ORDER BY funds.FundName, don.ArchticsID

CREATE NONCLUSTERED INDEX IDX_ArchticsID ON #GivingLevels (ArchticsID)
CREATE NONCLUSTERED INDEX IDX_FundName ON #GivingLevels (FundName)




/*========================================================================
	Aggregate donors with season ticket purchase info
========================================================================*/

SELECT funds.ID
	, CASE WHEN don.FundAbbreviation = 'CAR' THEN 'Gamecock Club' ELSE funds.FundType END AS FundType
	, CASE WHEN don.FundAbbreviation = 'CAR' THEN 'Car Dealer' ELSE funds.FundName END AS GivingLevel
	, SUM(CASE WHEN sth.PlanCode = @CYSeason THEN 1 END) AS CYNumAccounts
	, SUM(CASE WHEN sth.PlanCode = @PYSeason THEN 1 END) AS PYNumAccounts
	, SUM(CASE WHEN sth.PlanCode = @CYSeason THEN sth.Tickets END) AS CYTickets
	, SUM(CASE WHEN sth.PlanCode = @PYSeason THEN sth.Tickets END) AS PYTickets
INTO #Tickets
FROM rpt.GCFundLevels Funds
LEFT JOIN #GivingLevels don
	ON funds.FundAbbreviation = don.FundAbbreviation
	AND (don.Donation BETWEEN funds.MinDonation AND funds.MaxDonation)
LEFT JOIN rpt.vw_DonorSeasonTicketsBySportSeason sth
	ON don.ArchticsID = sth.ArchticsID
	AND RIGHT(don.DriveYear,2) = RIGHT(sth.PlanCode,2)
GROUP BY funds.ID
	, CASE WHEN don.FundAbbreviation = 'CAR' THEN 'Gamecock Club' ELSE funds.FundType END
	, CASE WHEN don.FundAbbreviation = 'CAR' THEN 'Car Dealer' ELSE funds.FundName END

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
