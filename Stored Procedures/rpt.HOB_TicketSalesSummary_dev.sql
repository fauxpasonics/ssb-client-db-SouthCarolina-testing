SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create PROCEDURE [rpt].[HOB_TicketSalesSummary_dev] (@SeasonName NVARCHAR(100)) 
AS

--DECLARE @SeasonName NVARCHAR(100) SET @SeasonName = '2017 Football';

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
    GroupGoalPct,
    StudentQty,
    StudentRevenue,
    ISNULL(eh.Custom_Dec_2,0) StudentGoal,
    StudentGoalPct,
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
JOIN rpt.Tmp_DimEventHeader eh
	ON tss.dimeventheaderid = eh.dimeventheaderid
WHERE SeasonName = @SeasonName
ORDER BY CalendarDate










GO
