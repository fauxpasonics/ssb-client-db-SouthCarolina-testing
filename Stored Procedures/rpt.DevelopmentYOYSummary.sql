SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [rpt].[DevelopmentYOYSummary] (@CYSeason NVARCHAR(100))
AS

--DECLARE @CYSeason NVARCHAR(100) = 'FB17' --drop table #donations --drop table #tickets
DECLARE @PYSeason NVARCHAR(100) = CONCAT(LEFT(@CYSeason,2),RIGHT(@CYSeason,2) - 1)


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
	, SUM(ISNULL(d.donation_paid_amount, 0)) paid_amount
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


SELECT d.apply_to_acct_id
	, d.drive_year
	, d.FundAbbreviation
	, d.paid_amount
	, g.FundType
	, g.GivingLevelName
	, g.MinDonation
	, g.MaxDonation
	, g.[Priority]
INTO #GivingLevels
FROM #Donations d
LEFT JOIN rpt.GCGivingLevels g
	ON d.FundAbbreviation = g.FundAbbreviation
	AND d.paid_amount BETWEEN g.MinDonation AND g.MaxDonation
WHERE d.FundAbbreviation IS NOT NULL
	AND g.GivingLevelName IS NOT NULL


SELECT g.*, cy.PlanCode, cy.Tickets
INTO #Tickets
FROM #GivingLevels g
LEFT JOIN rpt.vw_DonorSeasonTicketsBySportSeason cy
	ON g.apply_to_acct_id = cy.ArchticsID
	AND RIGHT(g.drive_year,2) = RIGHT(cy.PlanCode,2)
ORDER BY g.apply_to_acct_id, cy.PlanCode


SELECT t.drive_year, t.FundType, t.[Priority], t.GivingLevelName, COUNT(*) CYNumAccounts, SUM(t.Tickets) CYTickets
INTO #CY
FROM #Tickets t
LEFT JOIN (SELECT DISTINCT apply_to_acct_id
			FROM ods.TM_Donation
			WHERE fund_name LIKE '%CAR%'
				AND RIGHT(drive_year, 2) = RIGHT(@CYSeason,2)
		) car ON t.apply_to_acct_id = car.apply_to_acct_id
WHERE t.PlanCode = @CYSeason
	AND car.apply_to_acct_id IS NULL
GROUP BY t.drive_year, t.FundType, t.[Priority], t.GivingLevelName
--9502


SELECT t.drive_year, t.FundType, t.[Priority], t.GivingLevelName, COUNT(*) PYNumAccounts, SUM(t.Tickets) PYTickets
INTO #PY
FROM #Tickets t
LEFT JOIN (SELECT DISTINCT apply_to_acct_id
			FROM ods.TM_Donation
			WHERE fund_name LIKE '%CAR%'
				AND RIGHT(drive_year, 2) = RIGHT(@PYSeason,2)
		) car ON t.apply_to_acct_id = car.apply_to_acct_id
WHERE t.PlanCode = @PYSeason
	AND car.apply_to_acct_id IS NULL
GROUP BY t.drive_year, t.FundType, t.[Priority], t.GivingLevelName
--9502


SELECT COALESCE(c.FundType, p.FundType) FundType
	, COALESCE(c.GivingLevelName, p.GivingLevelName) GivingLevel
	, ISNULL(p.PYTickets, 0) PYTickets
	, ISNULL(p.PYNumAccounts, 0) PYNumAccounts
	, ISNULL(c.CYTickets, 0) CYTickets
	, ISNULL(c.CYNumAccounts, 0) CYNumAccounts
	, ISNULL(c.CYTickets, 0) - ISNULL(p.PYTickets, 0) AS TicketDifference
	, ISNULL(c.CYNumAccounts, 0) - ISNULL(p.PYNumAccounts, 0) AS MembershipDifference
FROM #CY c
FULL OUTER JOIN #PY p
	ON c.GivingLevelName = p.GivingLevelName
ORDER BY COALESCE(c.[Priority], p.[Priority])




GO
