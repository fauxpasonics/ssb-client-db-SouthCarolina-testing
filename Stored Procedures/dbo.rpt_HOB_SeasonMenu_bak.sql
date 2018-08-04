SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[rpt_HOB_SeasonMenu_bak]
AS


SELECT SeasonName
FROM dbo.DimSeasonHeader
WHERE SeasonName <> 'N/A'
AND SeasonName IN ('2016-2017 Men''s Basketball','2016-2017 Women''s Basketball','2016 Football')
ORDER BY SeasonCode
GO
