SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- View

CREATE VIEW [mdm].[vw_TM_STH] WITH SCHEMABINDING
AS
(
SELECT dc.DimCustomerId, dnr.DNR, sth.STH, (ISNULL(sc.QtySeat, 0) + ISNULL(tex.QtySeat, 0)) MaxSeatCount
	, COALESCE(sc.MaxTransDate, tex.MaxTransDate) MaxPurchaseDate, dc.AccountId
FROM dbo.DimCustomer dc (NOLOCK)
LEFT JOIN (
		SELECT DISTINCT dc.DimCustomerId, 1 DNR
		FROM dbo.DimCustomer dc (NOLOCK)
		JOIN ods.TM_Donation donor (NOLOCK)
			ON dc.AccountId = donor.acct_id
			AND dc.SourceSystem = 'TM'
			AND dc.CustomerType = 'Primary'
		WHERE donor.add_datetime >= (GETDATE() - 730)
	) dnr ON dc.DimCustomerId = dnr.DimCustomerId
LEFT JOIN (
		SELECT DISTINCT dimcustomerid, 1 AS STH
		FROM dbo.factticketsales f (NOLOCK)
		JOIN dbo.dimdate dd (NOLOCK)
			 ON f.DimDateId_OrigSale = dd.DimDateId
		WHERE f.DimTicketTypeId IN (1, 2, 5, 6, 8)
			AND dd.CalDate >= (GETDATE() - 730)
	) sth ON dc.DimCustomerId = sth.DimCustomerId
LEFT JOIN (
		SELECT f.DimCustomerId, SUM(f.QtySeat) QtySeat, MAX(dd.CalDate) MaxTransDate
		FROM dbo.FactTicketSales f (NOLOCK)
		JOIN dbo.dimdate dd (NOLOCK)
			 ON f.DimDateId_OrigSale = dd.DimDateId
		WHERE dd.CalDate >= (GETDATE() - 730)
		GROUP BY f.DimCustomerId
	) sc ON dc.DimCustomerId = sc.DimCustomerId
LEFT JOIN (
		SELECT dc.DimCustomerId, SUM(tex.num_seats) QtySeat, MAX(tex.add_datetime) MaxTransDate
		FROM ods.TM_Tex tex (NOLOCK)
		JOIN dbo.DimCustomer dc (NOLOCK)
			ON tex.assoc_acct_id = dc.AccountId
			AND dc.SourceSystem = 'TM'
			AND dc.CustomerType = 'Primary'
		WHERE tex.add_datetime >= (GETDATE() - 730)
		GROUP BY dc.DimCustomerId
	) tex ON dc.DimCustomerId = tex.DimCustomerId





)








GO
