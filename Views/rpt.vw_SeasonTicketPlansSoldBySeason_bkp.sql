SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [rpt].[vw_SeasonTicketPlansSoldBySeason_bkp]
AS

WITH MaxEventDate
AS (
	SELECT plan_event_name, MAX(event_Date) Event_Date
	FROM ods.TM_EventsInPlan (NOLOCK)
	WHERE (LEN(plan_event_name) = 4 AND LEN(event_name) = 8)
		OR (LEFT(plan_event_name,5) IN ('FB15-', 'FB16-', 'FB17-', 'FB18-', 'FB19-', 'BB15-', 'BB16-', 'BB17-', 'BB18-', 'BB19-', 'BB20-'))
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

SELECT p.PlanCode, sy.SchoolYear, sy.PrevSchoolYear, SUM(f.QtySeat) Tickets
FROM dbo.FactTicketSales f (NOLOCK)
JOIN dbo.DimPlan p (NOLOCK)
	ON f.DimPlanId = p.DimPlanId
JOIN dbo.dimevent e (NOLOCK)
	ON f.DimEventId = e.DimEventId
JOIN PlanEventPair pep
	ON p.PlanCode = pep.plan_event_name
	AND e.EventCode = pep.EventCode
JOIN [dbo].[Season_SchoolYear] sy (NOLOCK)
	ON LEFT(p.PlanCode,4) = sy.SeasonCode
GROUP BY p.PlanCode, sy.SchoolYear, sy.PrevSchoolYear




GO
