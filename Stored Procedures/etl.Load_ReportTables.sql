SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Load_ReportTables]
AS

-- Ticket Sales Report
EXECUTE etl.Load_HOB_TicketSalesSummary

EXECUTE etl.Load_SalesByTicketType

EXECUTE etl.Load_RunningDailyQtyRevenue


-- HOB Report
EXECUTE etl.Load_HOB_SeasonTicketSalesBySchoolYear

EXECUTE etl.Load_HOB_TicketSalesBySchoolYear

EXECUTE etl.Load_HOB_TicketSalesBySchoolYear_Chart




GO
