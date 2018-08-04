SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--EXEC [rpt].[HOB__SeasonTickesSalesBySchoolYear] '16-17'
CREATE PROCEDURE [rpt].[HOB__SeasonTickesSalesBySchoolYear] (@SchoolYear NVARCHAR(10))
AS

--Declare @schoolyear NVARCHAR(10) = '16-17'
SELECT
    Sport,
    CY,
    PY,
    CY_Tickets,
    PY_Tickets,
    CY_Revenue,
    PY_Revenue,
    CY_CntNew,
    PY_CntNew,
    CY_PctRenew,
    PY_PctRenew
FROM dbo.HOB_SeasonTicketSalesBySchoolYear
WHERE SchoolYear = @SchoolYear
ORDER BY Sport

GO
