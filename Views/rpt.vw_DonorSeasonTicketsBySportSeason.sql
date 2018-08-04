SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [rpt].[vw_DonorSeasonTicketsBySportSeason]
AS

WITH MaxEventDate
AS (
	SELECT plan_event_name, MAX(event_Date) Event_Date
	FROM ods.TM_EventsInPlan (NOLOCK)
	WHERE LEN(plan_event_name) = 4
	AND plan_group_name LIKE '%event%'
	GROUP BY plan_event_name

)

, PlanEventPair
AS (
	SELECT DISTINCT ds.DimSeasonId, ts.[name] SeasonName, ep.plan_event_name, ep.event_name EventCode
	FROM ods.TM_EventsInPlan ep (NOLOCK)
	JOIN MaxEventDate med
		ON ep.plan_event_name = med.plan_event_name
		AND ep.event_Date = med.Event_Date
	JOIN ods.TM_Season ts (NOLOCK) ON ep.season_id = ts.season_id
	JOIN dbo.DimSeason ds (NOLOCK) ON ts.[name] = ds.SeasonName
)

SELECT p.PlanCode, sy.SchoolYear, sy.PrevSchoolYear, f.SSID_acct_id ArchticsID, SUM(f.QtySeat) Tickets
FROM dbo.FactTicketSales f (NOLOCK)
JOIN dbo.DimPlan p (NOLOCK)
	ON f.DimPlanId = p.DimPlanId
JOIN dbo.dimevent e (NOLOCK)
	ON f.DimEventId = e.DimEventId
JOIN PlanEventPair pep
	ON p.PlanCode = pep.plan_event_name
	AND e.EventCode = pep.EventCode
JOIN [dbo].[Season_SchoolYear] sy (NOLOCK)
	ON p.PlanCode = sy.SeasonCode
JOIN dbo.DimPriceCode pc (NOLOCK)
	ON f.DimPriceCodeId = pc.DimPriceCodeId
WHERE pc.PriceCode NOT IN ('ADEV')
GROUP BY p.PlanCode, sy.SchoolYear, sy.PrevSchoolYear, f.SSID_acct_id







GO
