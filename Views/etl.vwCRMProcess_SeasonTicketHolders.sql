SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vwCRMProcess_SeasonTicketHolders]
AS

SELECT DISTINCT CAST(-2 AS VARCHAR(50)) SSID
, CAST(99 AS VARCHAR(50)) SeasonYear
, CAST(99 AS VARCHAR(50)) SeasonYr
       



GO
