SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Load_HOB_TicketSalesBySchoolYear_Chart]
AS

DECLARE @SchoolYear NVARCHAR(10)
DECLARE @PYSchoolYear NVARCHAR(10)
DECLARE @SQL1 NVARCHAR(MAX)

TRUNCATE TABLE dbo.HOB_TicketSalesBySchoolYear_Chart


SELECT *
INTO #WorkingSet
FROM rpt.vw_SchoolYear

WHILE 1=1
BEGIN
	SELECT TOP 1 @SchoolYear = SchoolYear
	FROM #WorkingSet

	IF @@ROWCOUNT = 0
		BREAK
	ELSE
		BEGIN

			SET @PYSchoolYear = (SELECT DISTINCT PrevSchoolYear FROM dbo.Season_SchoolYear WHERE SchoolYear = @SchoolYear)

			INSERT INTO dbo.HOB_TicketSalesBySchoolYear_Chart (SchoolYear, Sport, Tickets, Revenue, [Year])
			
				SELECT @SchoolYear
					, CASE WHEN a.Sport = 'BB' THEN 'MBB'
						ELSE a.Sport
						END AS Sport, 
					a.CYTickets AS Tickets, 
					a.CYRevenue AS Revenue,
					@SchoolYear Year
				FROM 
				(
					SELECT LEFT(ds.SeasonCode,2) Sport, SUM(fts.QtySeat) AS CYTickets, SUM(fts.TotalRevenue) AS CYRevenue
					FROM dbo.FactTicketSales fts
					JOIN dbo.DimSeason ds ON fts.DimSeasonId = ds.DimSeasonId
					JOIN dbo.Season_SchoolYear sy ON ds.SeasonCode = sy.SeasonCode
					WHERE sy.SchoolYear = @SchoolYear
					GROUP BY LEFT(ds.SeasonCode,2)
					--ORDER BY LEFT(ds.SeasonCode,2)
				) a
				UNION ALL
				select @SchoolYear,
					CASE WHEN b.Sport = 'BB' THEN 'MBB'
						ELSE b.Sport
						END Sport, 
					b.PYTickets AS Tickets,
					b.PYRevenue AS Revenue,
					@PYSchoolYear Year
				FROM 
				(
					SELECT LEFT(sy.PYSeasonCode,2) Sport, SUM(fts.QtySeat) AS PYTickets, SUM(fts.TotalRevenue) AS PYRevenue
					FROM dbo.FactTicketSales fts
					JOIN dbo.DimSeason ds ON fts.DimSeasonId = ds.DimSeasonId
					JOIN dbo.Season_SchoolYear sy ON ds.SeasonCode = sy.PYSeasonCode
					WHERE sy.SchoolYear = @SchoolYear
					GROUP BY LEFT(sy.PYSeasonCode,2)
					--ORDER BY LEFT(sy.PYSeasonCode,2)
				) b 
				UNION ALL

				SELECT @SchoolYear
					, 'GC' AS Sport
					, SUM(CASE WHEN RIGHT(fund_name,2) = RIGHT(@SchoolYear,2) THEN 1 END) AS CYTickets
					, SUM(CASE WHEN RIGHT(fund_name,2) = RIGHT(@SchoolYear,2) THEN donation_paid_amount END) AS CYRevenue
					--, SUM(CASE WHEN RIGHT(fund_name,2) = RIGHT(@PYSchoolYear,2) THEN 1 END) AS PYTickets
					--, SUM(CASE WHEN RIGHT(fund_name,2) = RIGHT(@PYSchoolYear,2) THEN donation_paid_amount END) AS PYRevenue
					, @SchoolYear
					--, @PYSchoolYear
				FROM ods.TM_Donation
				WHERE fund_name LIKE 'GC%' OR fund_name LIKE 'LFPY%'

				UNION ALL

				SELECT @SchoolYear
					, 'GC' AS Sport
					--, SUM(CASE WHEN RIGHT(fund_name,2) = RIGHT(@SchoolYear,2) THEN 1 END) AS CYTickets
					--, SUM(CASE WHEN RIGHT(fund_name,2) = RIGHT(@SchoolYear,2) THEN donation_paid_amount END) AS CYRevenue
					, SUM(CASE WHEN RIGHT(fund_name,2) = RIGHT(@PYSchoolYear,2) THEN 1 END) AS PYTickets
					, SUM(CASE WHEN RIGHT(fund_name,2) = RIGHT(@PYSchoolYear,2) THEN donation_paid_amount END) AS PYRevenue
					--, @SchoolYear
					, @PYSchoolYear
				FROM ods.TM_Donation
				WHERE fund_name LIKE 'GC%' OR fund_name LIKE 'LFPY%'
			;

			DELETE
			FROM #WorkingSet
			WHERE SchoolYear = @SchoolYear
			;

		END;

	CONTINUE
	;

END
;







GO
