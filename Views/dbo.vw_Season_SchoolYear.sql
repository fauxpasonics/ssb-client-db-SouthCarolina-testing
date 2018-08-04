SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_Season_SchoolYear]
AS

SELECT DISTINCT SeasonCode
	, CASE WHEN SeasonCode LIKE 'FB%' 
			OR SeasonCode LIKE 'VB%'
			OR SeasonCode LIKE 'MS%'
			OR SeasonCode LIKE 'WS%'
			OR SeasonCode LIKE 'WT%'
		THEN CONCAT(RIGHT(SeasonCode,2),'-',CAST(CAST(RIGHT(SeasonCode,2) AS INT) + 1 AS NVARCHAR(10)))
		WHEN SeasonCode LIKE 'BB%' 
			OR SeasonCode LIKE 'WB%'
			OR SeasonCode LIKE 'BS%'
			OR SeasonCode LIKE 'SB%'
			OR SeasonCode LIKE 'TF%'
		 THEN CONCAT(CAST(
			(CASE WHEN (CAST(RIGHT(SeasonCode,2) AS INT) - 1) < 10 THEN CONCAT('0',CAST(CAST(RIGHT(SeasonCode,2) AS INT) - 1 AS NVARCHAR(1)))
				ELSE CAST(RIGHT(SeasonCode,2) AS INT) - 1
				END)
			 AS NVARCHAR(10)),'-',RIGHT(SeasonCode,2))
		ELSE NULL END AS 'Year'
FROM dbo.DimSeason
WHERE SeasonCode LIKE 'FB%'
	OR SeasonCode LIKE 'VB%'
	OR SeasonCode LIKE 'MS%'
	OR SeasonCode LIKE 'WS%'
	OR SeasonCode LIKE 'WT%'
	OR SeasonCode LIKE 'BB%' 
	OR SeasonCode LIKE 'WB%'
	OR SeasonCode LIKE 'BS%'
	OR SeasonCode LIKE 'SB%'
	OR SeasonCode LIKE 'TF%'
GO
