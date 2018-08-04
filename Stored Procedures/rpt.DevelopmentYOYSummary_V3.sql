SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [rpt].[DevelopmentYOYSummary_V3] (@CYSeason NVARCHAR(100))
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
--DECLARE @CYSeason NVARCHAR(100) = 'FB17' drop table #donations --drop table #tickets
DECLARE @PYSeason NVARCHAR(100) = CONCAT(LEFT(@CYSeason,2),RIGHT(@CYSeason,2) - 1)


/*========================================================================
	Pull donation info
========================================================================*/
SELECT d.apply_to_acct_id
	, d.drive_year
	--, d.fund_name
	, CASE WHEN d.fund_name LIKE 'GC%' THEN 'GC'
		WHEN d.fund_name LIKE '1A3640%' THEN 'GC'
		WHEN d.fund_name LIKE '1B1649%' THEN 'GC'
		WHEN d.fund_name LIKE 'MTCH%' THEN 'GC'
		WHEN d.fund_name LIKE 'SGC%' THEN 'SGC'
		WHEN d.fund_name LIKE 'JR%' THEN 'JR'
		WHEN d.fund_name LIKE 'LFPY%' THEN 'LFPY'
		ELSE NULL END AS FundAbbreviation
	, SUM(ISNULL(d.donation_paid_amount, 0)) pledge_amount
INTO #Donations
FROM ods.TM_Donation d
GROUP BY d.apply_to_acct_id, d.drive_year
	, CASE WHEN d.fund_name LIKE 'GC%' THEN 'GC'
		WHEN d.fund_name LIKE '1A3640%' THEN 'GC'
		WHEN d.fund_name LIKE '1B1649%' THEN 'GC'
		WHEN d.fund_name LIKE 'MTCH%' THEN 'GC'
		WHEN d.fund_name LIKE 'SGC%' THEN 'SGC'
		WHEN d.fund_name LIKE 'JR%' THEN 'JR'
		WHEN d.fund_name LIKE 'LFPY%' THEN 'LFPY'
		ELSE NULL END
--34031

CREATE NONCLUSTERED INDEX IDX_ArchticsID ON #Donations (apply_to_acct_id)
CREATE NONCLUSTERED INDEX IDX_FundAbbreviation ON #Donations (FundAbbreviation)
--414356


SELECT d.apply_to_acct_id, d.drive_year, d.FundAbbreviation, d.pledge_amount
	, g.[Priority], g.FundType, g.GivingLevelName, g.MinDonation, g.MaxDonation
	, cy.PlanCode CYPlanCode, cy.Tickets CYTickets
	, py.PlanCode PYPlanCode, py.Tickets PYTickets
INTO #Tickets
FROM rpt.GCGivingLevels g
LEFT JOIN #Donations d
	ON d.FundAbbreviation = g.FundAbbreviation
	AND d.pledge_amount BETWEEN g.MinDonation AND g.MaxDonation
LEFT JOIN rpt.vw_DonorSeasonTicketsBySportSeason cy
	ON d.apply_to_acct_id = cy.ArchticsID
	AND RIGHT(d.drive_year,2) = RIGHT(cy.PlanCode,2)
LEFT JOIN rpt.vw_DonorSeasonTicketsBySportSeason py
	ON d.apply_to_acct_id = py.ArchticsID
	AND (CAST(RIGHT(d.drive_year,2) AS INT) - 1) = CAST(RIGHT(py.PlanCode,2) AS INT)
	AND LEFT(cy.PlanCode,2) = LEFT(py.PlanCode,2)
ORDER BY d.apply_to_acct_id, CYPlanCode


SELECT DISTINCT apply_to_acct_id, drive_year
INTO #CarDealers
FROM ods.TM_Donation
WHERE fund_name LIKE '%CAR%'


/*========================================================================
	Calculate Delta
========================================================================*/

SELECT t.drive_year DriveYear
	, t.FundType
	, t.[Priority]
	, t.GivingLevelName GivingLevel
	, SUM(t.PYTickets) PYTickets
	, SUM(CASE WHEN t.PYPlanCode IS NOT NULL THEN 1 ELSE 0 END) AS PYAccounts
	, SUM(t.CYTickets) CYTickets
	, SUM(CASE WHEN t.CYPlanCode IS NOT NULL THEN 1 ELSE 0 END) AS CYAccounts
INTO #Final
FROM #Tickets t
LEFT JOIN #CarDealers c
	ON t.apply_to_acct_id = c.apply_to_acct_id
	AND t.drive_year = c.drive_year
WHERE c.apply_to_acct_id IS NULL
	AND @CYSeason = t.CYPlanCode
	AND t.FundType IS NOT NULL
GROUP BY t.drive_year, t.CYPlanCode, t.FundType, t.[Priority], t.GivingLevelName
ORDER BY DriveYear, [Priority]


SELECT g.FundType, g.[Priority], g.GivingLevelName GivingLevel
	, ISNULL(PYTickets, 0) PYTickets
	, ISNULL(PYAccounts, 0) PYNumAccounts
	, ISNULL(CYTickets, 0) CYTickets
	, ISNULL(CYAccounts, 0) CYNumAccounts
	, ISNULL(f.CYTickets, 0) - ISNULL(f.PYTickets, 0) AS TicketDifference
	, ISNULL(f.CYAccounts, 0) - ISNULL(f.PYAccounts, 0) AS MembershipDifference
FROM rpt.GCGivingLevels g
LEFT JOIN #Final f
	ON g.GivingLevelName = f.GivingLevel
ORDER BY [Priority]




GO
