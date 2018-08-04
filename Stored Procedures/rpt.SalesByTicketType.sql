SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--EXEC [rpt].[SalesByTicketType] '2016 Football'
CREATE PROCEDURE [rpt].[SalesByTicketType] (@Season NVARCHAR(50))--, @SeasonCode NVARCHAR(10) = NULL, @PreviousSeasonCode NVARCHAR(10) = NULL)
AS
SET NOCOUNT ON

--DECLARE @Season NVARCHAR(50) = '2016 Football'


SELECT * FROM dbo.SalesByTicketType
WHERE Season = @Season
ORDER BY SeasonCode DESC, TicketTypeName
GO
