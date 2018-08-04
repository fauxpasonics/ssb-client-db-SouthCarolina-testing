SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*=============================================================
Procedure:		rpt.RunningDailyQtyRevenue '2016 Football'
Creator:		Travis Hofmeister
Create Date:	2017-05-17
Purpose:		Generate daily sales totals and running sales
				totals for ticket quantities and revenue
=============================================================*/

CREATE PROCEDURE [rpt].[RunningDailyQtyRevenue] (@Season NVARCHAR(150))
AS

--DECLARE @Season NVARCHAR(150) = '2016 Football';

SELECT TicketTypeName,
    SaleDate,
    DaysOfRenewalCycle,
    DailyRevenue,
    RunningSales,
    DailyQty,
    RunningQty
FROM dbo.RunningDailyQtyRevenue
WHERE Season = @Season
ORDER BY TicketTypeName, SaleDate




GO
