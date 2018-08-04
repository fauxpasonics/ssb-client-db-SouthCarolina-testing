SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [rpt].[HOB__TickesSalesBySchoolYear]  (@SchoolYear NVARCHAR(10))
AS

--DECLARE @SchoolYear NVARCHAR(10) = '17-18'
SELECT Sport,
    CYSeatDonationQty,
    CYSeatDonationRevenue,
    CYTickets,
    CYRevenue,
    PYSeatDonationQty,
    PYSeatDonationRevenue,
    PYTickets,
    PYRevenue,
    CY,
    PY
FROM dbo.HOB_TicketSalesBySchoolYear
WHERE SchoolYear = @SchoolYear
ORDER BY Sport











GO
