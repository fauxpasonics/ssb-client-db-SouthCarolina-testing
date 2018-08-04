SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [rpt].[vw_SeasonTicketPlansSoldBySeason_CustomerLevel]
AS

WITH MaxEventDate
AS (
	SELECT f.SSID_acct_id, s.DimSeasonId, s.SeasonName, p.PlanCode, MAX(e.EventDate) EventDate
	FROM dbo.FactTicketSales f (NOLOCK)
	JOIN dbo.DimPlan p (NOLOCK)
		ON f.DimPlanId = p.DimPlanId
	JOIN dbo.dimevent e (NOLOCK)
		ON f.DimEventId = e.DimEventId
	JOIN dbo.DimSeason s (NOLOCK)
		ON f.DimSeasonId = s.DimSeasonId
	WHERE ((LEN(p.PlanCode) = 4 AND LEN(e.EventCode) = 8)
		OR (LEFT(p.PlanCode,5) IN ('FB15-', 'FB16-', 'FB17-', 'FB18-', 'FB19-'
				, 'BB15-', 'BB16-', 'BB17-', 'BB18-', 'BB19-', 'BB20-')))
		AND p.PlanCode <> 'None'
	GROUP BY f.SSID_acct_id, s.DimSeasonId, s.SeasonName, p.PlanCode
)


SELECT ssbid.SSB_CRMSYSTEM_CONTACT_ID, LEFT(p.PlanCode, 4) SeasonCode, sy.SchoolYear
	, sy.PrevSchoolYear, sy.PYSeasonCode
	, nsy.SchoolYear NextSchoolYear, nsy.SeasonCode NextSeasonCode
	--, CASE WHEN f.DimPlanTypeId = 1 THEN 'New'
	--	WHEN f.DimPlanTypeId = 2 THEN 'Renew'
	--	ELSE 'Others' END AS Category
	, SUM(f.QtySeat) Tickets
FROM dbo.FactTicketSales f (NOLOCK)
JOIN dbo.DimPlan p (NOLOCK)
	ON f.DimPlanId = p.DimPlanId
JOIN dbo.dimevent e (NOLOCK)
	ON f.DimEventId = e.DimEventId
JOIN dbo.DimSeason s (NOLOCK)
	ON f.DimSeasonId = s.DimSeasonId
JOIN MaxEventDate med
	ON med.DimSeasonId = s.DimSeasonId
	AND med.PlanCode = p.PlanCode
	AND med.SSID_acct_id = f.SSID_acct_id
	AND med.EventDate = e.EventDate
JOIN dbo.Season_SchoolYear sy (NOLOCK)
	ON LEFT(p.PlanCode,4) = sy.SeasonCode
JOIN dbo.dimcustomerssbid ssbid (NOLOCK)
	ON f.DimCustomerId = ssbid.DimCustomerID
LEFT JOIN dbo.Season_SchoolYear nsy(NOLOCK)
	ON LEFT(p.PlanCode,4) = nsy.PYSeasonCode
WHERE ((LEN(p.PlanCode) = 4 AND LEN(e.EventCode) = 8)
	OR (LEFT(p.PlanCode,5) IN ('FB15-', 'FB16-', 'FB17-', 'FB18-', 'FB19-'
			, 'BB15-', 'BB16-', 'BB17-', 'BB18-', 'BB19-', 'BB20-')))
	AND p.PlanCode <> 'NONE'
GROUP BY ssbid.SSB_CRMSYSTEM_CONTACT_ID, LEFT(p.PlanCode, 4), sy.SchoolYear
	, sy.PrevSchoolYear, sy.PYSeasonCode
	, nsy.SchoolYear, nsy.SeasonCode
	--, CASE WHEN f.DimPlanTypeId = 1 THEN 'New'
	--	WHEN f.DimPlanTypeId = 2 THEN 'Renew'
	--	ELSE 'Others' END
--ORDER BY ssbid.SSB_CRMSYSTEM_CONTACT_ID, p.PlanCode


--SELECT * FROM dbo.Season_SchoolYear


GO
