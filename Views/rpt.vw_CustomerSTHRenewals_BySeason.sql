SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [rpt].[vw_CustomerSTHRenewals_BySeason]
AS

SELECT COALESCE(cy.SSB_CRMSYSTEM_CONTACT_ID, py.SSB_CRMSYSTEM_CONTACT_ID) SSB_CRMSYSTEM_CONTACT_ID
	, COALESCE(cy.SeasonCode, py.NextSeasonCode) AS SeasonCode
	, COALESCE(cy.SchoolYear, py.NextSchoolYear) SchoolYear
	, COALESCE(cy.PrevSchoolYear, py.SchoolYear) PrevSchoolYear
	, ISNULL(cy.Tickets, 0) AS CYTickets
	, ISNULL(py.Tickets, 0) AS PYTickets
	, CASE WHEN ISNULL(cy.Tickets, 0) = 0 THEN 0
		WHEN ISNULL(cy.Tickets, 0) >= ISNULL(py.Tickets, 0) THEN 100
		ELSE CAST(((CAST(ISNULL(cy.Tickets, 0) AS DECIMAL(10,2))/CAST(ISNULL(py.Tickets, 0) AS DECIMAL(10,2)))*100) AS DECIMAL(10,2))
		END AS RenewalPercent
	, CASE WHEN ISNULL(cy.Tickets, 0) = 0 AND ISNULL(py.Tickets, 0) > 0 THEN 'Not Renewed'
		WHEN ISNULL(cy.Tickets, 0) > 0 AND ISNULL(py.Tickets, 0) = 0 THEN 'New'
		ELSE 'Renewed'
		END AS RenewalStatus
--SELECT *
FROM rpt.vw_SeasonTicketPlansSoldBySeason_CustomerLevel cy (NOLOCK)
FULL OUTER JOIN rpt.vw_SeasonTicketPlansSoldBySeason_CustomerLevel py (NOLOCK)
	ON cy.SSB_CRMSYSTEM_CONTACT_ID = py.SSB_CRMSYSTEM_CONTACT_ID
	AND cy.PrevSchoolYear = py.SchoolYear
	AND LEFT(cy.SeasonCode, 2) = LEFT(py.SeasonCode, 2)
WHERE COALESCE(cy.SeasonCode, py.NextSeasonCode) IS NOT NULL
--ORDER BY cy.SSB_CRMSYSTEM_CONTACT_ID, cy.SeasonCode







GO
