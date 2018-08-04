SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [rpt].[HOB_TicketSalesSummary] (@SeasonName NVARCHAR(100)) 
AS

--DECLARE @SeasonName NVARCHAR(100) SET @SeasonName = '2016 Football';

SELECT
	tss.DimEventHeaderID,
	tss.SeasonName,
    tss.EventName,
    tss.EventDate,
    VisitorQty,
    VisitorRevenue,
    WalkUpQty,
    WalkUpRevenue,
    STHQty,
    STHRevenue,
    MiniPlanQty,
    MiniPlanRevenue,
    PartialPlanQty,
    PartialPlanRevenue,
    FlexPlanQty,
    FlexPlanRevenue,
    GroupQty,
    GroupRevenue,
    ISNULL(eh.Custom_Dec_1,0) GroupGoal,
	ISNULL(CAST(tss.GroupQty AS DECIMAL(18,6))/NULLIF(eh.Custom_Dec_1,0),0) AS GroupGoalPct,
    --GroupGoalPct,
    StudentQty,
    StudentRevenue,
    ISNULL(eh.Custom_Dec_2,0) StudentGoal,
	ISNULL(CAST(tss.StudentQty AS DECIMAL(18,6))/NULLIF(eh.Custom_Dec_2,0),0) AS StudentGoalPct,
    --StudentGoalPct,
    SingleGameQty,
    SingleGameRevenue,
    ArchticsSingleGameQty,
    ArchticsSingleGameRevenue,
    MobileQty,
    MobileRevenue,
	TotalSingleGameSales,
	TotalSingleGameSalesRevenue,
    TotalSold,
    TotalScanned,
    AvailableQty,
    PctAttended,
    TicketExchangeQty,
    TicketExchangeRevenue,
	TotalRevenue
FROM dbo.HOB_TicketSalesSummary (NOLOCK) tss
JOIN dbo.DimEventHeader eh
	ON tss.dimeventheaderid = eh.dimeventheaderid
WHERE SeasonName = @SeasonName
ORDER BY CalendarDate









GO
