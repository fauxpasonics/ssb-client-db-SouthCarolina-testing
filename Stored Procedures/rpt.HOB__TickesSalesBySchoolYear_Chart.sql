SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [rpt].[HOB__TickesSalesBySchoolYear_Chart]  (@SchoolYear NVARCHAR(10))
AS

--DECLARE @SchoolYear NVARCHAR(10) = '17-18'

SELECT Sport,
	--Tickets,
	--Revenue,
	--[Year]
    CYTickets AS Tickets,
    CYRevenue AS Revenue,
    SchoolYear AS [Year]
--FROM dbo.HOB_TicketSalesBySchoolYear_Chart
FROM dbo.HOB_TicketSalesBySchoolYear a
WHERE SchoolYear = @SchoolYear

UNION ALL

SELECT b.Sport,
    b.CYTickets AS Tickets,
    b.CYRevenue AS Revenue,
    b.SchoolYear AS [Year]
FROM dbo.HOB_TicketSalesBySchoolYear a
JOIN dbo.HOB_TicketSalesBySchoolYear b
	ON a.PY = b.CY
	AND a.Sport = b.Sport
WHERE a.SchoolYear = @SchoolYear
ORDER BY Sport


GO
