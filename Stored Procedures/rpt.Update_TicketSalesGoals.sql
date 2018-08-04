SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE proc [rpt].[Update_TicketSalesGoals] (@DimEventHeaderId int, @GroupGoal dec(18,2), @StudentGoal dec(18,2))
AS
/*
SELECT *
--into rpt.Tmp_DimEventHeader
FROM rpt.Tmp_DimEventHeader --[SouthCarolina].[dbo].[DimEventHeader]
--where EventHierarchyL2 = 'Football'
where eventdate > '1/1/2016'
	and EventHierarchyL3 = 'Regular Season'

DECLARE @DimEventHeaderId int = 646
DECLARE @GroupGoal dec(18,2) = 200
DECLARE @StudentGoal dec(18,2) = 0
*/
--create table rpt.TmpParams (DimEventHeaderId int, GroupGoal dec(18,2), StudentGoal dec(18,2), InsertDate datetime)
--insert into rpt.TmpParams values (@DimEventHeaderId, @GroupGoal, @StudentGoal, getdate())
--select * From rpt.tmpparams order by insertdate desc


UPDATE [SouthCarolina].[dbo].[DimEventHeader]
SET
	Custom_Dec_1 = @GroupGoal,
	Custom_Dec_2 = @StudentGoal
WHERE DimEventHeaderId = @DimEventHeaderId
GO
