SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Load_HOB_TicketSalesBySchoolYear]
AS

DECLARE @SchoolYear NVARCHAR(10)
DECLARE @PYSchoolYear NVARCHAR(10)
DECLARE @SQL1 NVARCHAR(MAX)

TRUNCATE TABLE dbo.HOB_TicketSalesBySchoolYear


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

			INSERT INTO dbo.HOB_TicketSalesBySchoolYear	(SchoolYear, Sport, CYSeatDonationQty, CYSeatDonationRevenue,
				CYTickets, CYRevenue, PYSeatDonationQty, PYSeatDonationRevenue, PYTickets, PYRevenue, CY, PY)

				SELECT @SchoolYear
					, CASE WHEN COALESCE(a.Sport, b.Sport) = 'BB' THEN 'MBB'
						ELSE COALESCE(a.Sport, b.Sport)
						END AS Sport
					, a.CYSeatDonationQty AS CYSeatDonationQty
					, a.CYSeatDonationRevenue AS CYSeatDonationRevenue
					, a.CYTickets AS CYTickets
					, a.CYRevenue AS CYRevenue
					, b.PYSeatDonationQty AS PYSeatDonationQty
					, b.PYSeatDonationRevenue AS PYSeatDonationsRevenue
					, b.PYTickets AS PYTickets
					, b.PYRevenue AS PYRevenue
					, @SchoolYear CY
					, @PYSchoolYear PY
				FROM 
				(
					SELECT LEFT(ds.SeasonCode,2) Sport
						, SUM(CASE WHEN fts.DimTicketTypeID = 12 THEN fts.QtySeat END) CYSeatDonationQty
						, SUM(CASE WHEN fts.DimTicketTypeID = 12 THEN fts.TotalRevenue END) CYSeatDonationRevenue
						, SUM(CASE WHEN fts.DimTicketTypeId <> 12 AND de.EventClass IN ('Game', 'Handling Fee') THEN fts.QtySeat END) AS CYTickets
						, SUM(CASE WHEN fts.DimTicketTypeId <> 12 AND de.EventClass IN ('Game', 'Handling Fee') THEN fts.TotalRevenue END) AS CYRevenue
					FROM dbo.FactTicketSales fts
					JOIN dbo.DimSeason ds ON fts.DimSeasonId = ds.DimSeasonId
					JOIN dbo.Season_SchoolYear sy ON ds.SeasonCode = sy.SeasonCode
					JOIN dbo.DimEvent de ON fts.DimEventId = de.DimEventId
					LEFT JOIN dbo.SeatDonations sd ON fts.DimPriceCodeId = sd.DimPriceCodeID
					WHERE sy.SchoolYear = @SchoolYear
					GROUP BY LEFT(ds.SeasonCode,2)	
				) a
				FULL OUTER JOIN 
				(
					SELECT LEFT(sy.PYSeasonCode,2) Sport
						, SUM(CASE WHEN fts.DimTicketTypeID = 12 THEN fts.QtySeat END) PYSeatDonationQty
						, SUM(CASE WHEN fts.DimTicketTypeID = 12 THEN fts.TotalRevenue END) PYSeatDonationRevenue
						, SUM(CASE WHEN fts.DimTicketTypeID <> 12 AND de.EventClass IN ('Game', 'Handling Fee') THEN fts.QtySeat END) AS PYTickets
						, SUM(CASE WHEN fts.DimTicketTypeID <> 12 AND de.EventClass IN ('Game', 'Handling Fee') THEN fts.TotalRevenue END) AS PYRevenue
					FROM dbo.FactTicketSales fts
					JOIN dbo.DimSeason ds ON fts.DimSeasonId = ds.DimSeasonId
					JOIN dbo.Season_SchoolYear sy ON ds.SeasonCode = sy.PYSeasonCode
					JOIN dbo.DimEvent de ON fts.DimEventId = de.DimEventId
					LEFT JOIN dbo.SeatDonations sd ON fts.DimPriceCodeId = sd.DimPriceCodeID
					WHERE sy.SchoolYear = @SchoolYear
					GROUP BY LEFT(sy.PYSeasonCode,2)
				--ORDER BY LEFT(sy.PYSeasonCode,2)
				) b 
					on a.Sport = b.Sport

				UNION ALL

				SELECT @SchoolYear
					, 'GC' AS Sport
					, NULL AS CYSeatDonationsQty
					, NULL AS CYSeatDonationRevenue
					, SUM(CASE WHEN RIGHT(fund_name,2) = RIGHT(@SchoolYear,2) THEN 1 END) AS CYTickets
					, SUM(CASE WHEN RIGHT(fund_name,2) = RIGHT(@SchoolYear,2) THEN donation_paid_amount END) AS CYRevenue
					, NULL AS PYSeatDonationsQty
					, NULL AS PYSeatDonationsRevenue
					, SUM(CASE WHEN RIGHT(fund_name,2) = RIGHT(@PYSchoolYear,2) THEN 1 END) AS PYTickets
					, SUM(CASE WHEN RIGHT(fund_name,2) = RIGHT(@PYSchoolYear,2) THEN donation_paid_amount END) AS PYRevenue
					, @SchoolYear
					, @PYSchoolYear
				FROM ods.TM_Donation
				WHERE fund_name LIKE 'GC%' OR fund_name LIKE 'LFPY%'
				ORDER BY CASE WHEN COALESCE(a.Sport, b.Sport) = 'BB' THEN 'MBB'
						ELSE COALESCE(a.Sport, b.Sport)
						END
				;

			DELETE
			FROM #WorkingSet
			WHERE SchoolYear = @SchoolYear
			;

		END
		;

	CONTINUE
	;

END
;















GO
