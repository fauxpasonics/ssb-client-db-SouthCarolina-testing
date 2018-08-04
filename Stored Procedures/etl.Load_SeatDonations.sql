SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Load_SeatDonations]
AS

INSERT INTO dbo.SeatDonations (DimPriceCodeID, PriceCode, PriceCodeDesc, Price, SeatDonationPrice, SeatDonationType, DimSeasonID, SeasonName, SeasonYear)

SELECT pc.DimPriceCodeId, pc.PriceCode, pc.PriceCodeDesc, pc.Price, NULL
	, CASE	WHEN pc.PriceCodeDesc LIKE '%Garnet%'
				OR (s.SeasonCode IN ('FB15', 'FB16') AND pc.ParentPriceCode IN ('F', 'M', 'T'))
				OR (s.SeasonCode IN ('FB17', 'FB18') AND pc.ParentPriceCode IN ('E'))
			THEN 'Garnet'
			WHEN pc.PriceCodeDesc LIKE '%Red%'
				OR (s.SeasonCode IN ('FB15', 'FB16') AND pc.ParentPriceCode IN ('G', 'N', 'U'))
				OR (s.SeasonCode IN ('FB17', 'FB18') AND pc.ParentPriceCode IN ('F'))
			THEN 'Red'
			WHEN pc.PriceCodeDesc LIKE '%Grey%'
				OR (s.SeasonCode IN ('FB15', 'FB16') AND pc.ParentPriceCode IN ('H', 'O', 'V'))
				OR (s.SeasonCode IN ('FB17', 'FB18') AND pc.ParentPriceCode IN ('G'))
			THEN 'Grey'
			WHEN pc.PriceCodeDesc LIKE '%Blue%'
				OR (s.SeasonCode IN ('FB15', 'FB16') AND pc.ParentPriceCode IN ('I', 'P', 'W'))
				OR (s.SeasonCode IN ('FB17', 'FB18') AND pc.ParentPriceCode IN ('H'))
			THEN 'Blue'
			WHEN pc.PriceCodeDesc LIKE '%Green%'
				OR (s.SeasonCode IN ('FB15', 'FB16') AND pc.ParentPriceCode IN ('J', 'Q', 'X'))
				OR (s.SeasonCode IN ('FB17', 'FB18') AND pc.ParentPriceCode IN ('I'))
			THEN 'Green'
			WHEN pc.PriceCodeDesc LIKE '%Yellow%'
				OR (s.SeasonCode IN ('FB15', 'FB16') AND pc.ParentPriceCode IN ('K', 'R', 'Y'))
				OR (s.SeasonCode IN ('FB17', 'FB18') AND pc.ParentPriceCode IN ('J'))
			THEN 'Yellow'
			WHEN pc.PriceCodeDesc LIKE '%Black%'
				OR (s.SeasonCode IN ('FB15', 'FB16') AND pc.ParentPriceCode IN ('L', 'S', 'Z'))
				OR (s.SeasonCode IN ('FB17', 'FB18') AND pc.ParentPriceCode IN ('K'))
			THEN 'Black'
			ELSE NULL END
	, pc.DimSeasonId, s.SeasonName, s.SeasonYear
FROM dbo.DimPriceCode pc
LEFT JOIN dbo.SeatDonations sd
	ON pc.DimPriceCodeId = sd.DimPriceCodeID
LEFT JOIN dbo.DimSeason s
	ON pc.DimSeasonId = s.DimSeasonId
WHERE sd.DimPriceCodeID IS NULL
	AND pc.PriceCodeDesc LIKE '%seat donation%'


UPDATE a
SET a.NeedsReview = b.NeedsReview
	, a.ReviewCompletedDate = CASE WHEN b.NeedsReview = 0 THEN GETDATE() ELSE NULL END
FROM dbo.SeatDonations a
LEFT JOIN (
	SELECT b.SeatDonationID
		, CASE WHEN (ISNULL(b.Price, 0.00) = 0.00
					OR ISNULL(b.SeatDonationPrice, 0.00) = 0.00
					OR ISNULL(b.SeatDonationType, '') = '')
							AND b.ReviewCompletedDate IS NULL THEN 1 ELSE 0 END AS NeedsReview
	FROM dbo.SeatDonations b
) b ON a.SeatDonationID = b.SeatDonationID

GO
