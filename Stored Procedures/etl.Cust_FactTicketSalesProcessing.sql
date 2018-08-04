SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE   PROCEDURE [etl].[Cust_FactTicketSalesProcessing]
(
	@BatchId INT = 0,
	@LoadDate DATETIME = NULL,
	@Options NVARCHAR(MAX) = NULL
)

AS


BEGIN

/*****************************************************************************************************************
															PLAN TYPE
******************************************************************************************************************/

---------------------Football---------------------

----NEW----

UPDATE fts
SET fts.DimPlanTypeId = 1
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE   ((SeasonCode = 'FB15' AND (
				(PriceCode LIKE '[F-L]4%[A-G]')
				OR (PriceCode LIKE '[M-S]4%')
				)
		)
		OR (SeasonCode = 'FB16' AND (
				(PriceCode LIKE '[F-L]%[A-G]')
				OR (PriceCode LIKE '[M-S]4%')
				OR (PriceCode IN ('KINR', 'KYA1', 'KYI1', 'KYNR', 'LINR', 'LYA1', 'LYI1', 'LYNR'))
				)
		)
		OR (SeasonCode IN ('FB17', 'FB18') AND (
				(PriceCode IN ('1IBN', '1IFN', 'KYI1', 'KYA1')
				))
		))
		AND LEN(PriceCode) > 1

	
		

----RENEW----

UPDATE fts
SET fts.DimPlanTypeId = 2
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE   ((SeasonCode = 'FB15' AND (
				(PriceCode LIKE '[F-L]I%[1-7]')
				OR (PriceCode LIKE '[M-S]I%[M-S]')
				OR (PriceCode LIKE '[B-L]%[1-7]')
				OR (PriceCode LIKE '[M-S]%[1-7]')
				)
		)
		OR (SeasonCode = 'FB16' AND (
				(PriceCode LIKE '[A-L]%[1-7]' AND PriceCode NOT IN ('KINR', 'KYA1', 'KYI1', 'KYNR', 'LINR', 'LYA1', 'LYI1', 'LYNR'))
				OR (PriceCode LIKE '[M-S]%[M-S]')
				OR (PriceCode LIKE '[B-L]%[1-7]')
				OR (PriceCode LIKE '[M-S]%[1-7]' AND PC2 <> '4')
				AND LEN(PriceCode) > 1
				)
		OR (SeasonCode IN ('FB17', 'FB18') AND 
				(PriceCode IN ('1IBR', '1IFR', 'KYI2', 'KYA2', 'SSTE')
				OR (PriceCode LIKE '[E-K]%' AND PriceCode LIKE '%LT')
				OR (PriceCode IN ('ER1', '1B'))
				OR (PriceCode LIKE '[F-K]I%')
				) AND LEN(PriceCode) > 1
				)
		))



----Non Renewable or Priority----

UPDATE fts
SET fts.DimPlanTypeId = 3
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE   ((SeasonCode = 'FB15' AND PriceCode LIKE '[T-Z]%[1-7]')
		OR (SeasonCode = 'FB16' AND (
				(PriceCode LIKE '[T-Z]%' AND LEN(PriceCode) > 1)
				OR (PriceCode IN ('KYNR', 'LINR', 'KINR'))
				)
			)
		OR (SeasonCode IN ('FB17', 'FB18') AND PriceCode = 'IBNP')
		)
		AND LEN(PriceCode) > 1



----ZERO VALUE----

UPDATE fts
SET fts.DimPlanTypeId = 4
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE   LEN(PriceCode) = 1
AND		SeasonCode LIKE 'FB%'



----COMP----

UPDATE fts
SET fts.DimPlanTypeId = 5
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE   (SeasonCode IN ('FB15', 'FB16') AND PriceCode = 'A0C')
		OR (SeasonCode IN ('FB17', 'FB18') AND (PriceCode LIKE '[A-K]%C' OR PriceCode IN ('1C')))




---------------------Men's Basketball 2016-2017---------------------

----NEW----

UPDATE fts
SET fts.DimPlanTypeId = 1
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE   (SeasonCode = 'BB16' AND PriceCode IN ('GMA', 'HMB', 'IMC', 'JME', 'KMF', 'TMD', 'MMG', 'NMH'))
		OR (SeasonCode = 'BB17' AND PriceCode.PriceCode IN ('GMA','HMB','IMC','JME','MMG','NMH', 'YAL'))
		OR (SeasonCode = 'BB18' AND PriceCode IN ('AMA', 'BMA', 'CMB', 'EMC', 'DME', 'FMF', 'GMC', 'HJY', 'CMG', 'DMH'))

	
		

----RENEW----

UPDATE fts
SET fts.DimPlanTypeId = 2
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE   (SeasonCode = 'BB16' AND PriceCode IN ('GBA','GIA','HBB','HIB', 'HMT','IBC','IIC', 'IMT', 'JBD','JIE','KBE','KIF','KMT', 'TBT', 'TID', 'MBH','MIG','NIH','NBI', 'RAD', 'SBS'))
		OR (SeasonCode = 'BB17' AND PriceCode IN ('GBA','GIA','HBB','HIB','IBC','IIC','JBD','JIE','KBE','KIF','KMT','MBH','MIG','NIH','NBI', 'SBS', 'RAD', 'RAD1'))
		OR (SeasonCode = 'BB18' AND PriceCode IN ('AFC', 'AIA', 'BFC', 'BIA', 'CBB', 'CIB', 'EBC', 'EIC', 'DBD', 'DIE', 'FBE', 'FIF', 'GBC', 'GIC', 'HJY2', 'CBH', 'CIG', 'DIH', 'DBI', 'RAD1'))




----No Plan----

UPDATE fts
SET fts.DimPlanTypeId = 6
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE   PriceCode LIKE '[A-T]'
AND		SeasonCode LIKE 'BB%'



----Comp----

UPDATE fts
SET fts.DimPlanTypeId = 5
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE   (SeasonCode IN ('BB16', 'BB17') AND PriceCode = 'QBP')
		OR (SeasonCode = 'BB18' AND PriceCode IN ('A0C', 'B0C', 'C0C', 'D0C', 'E0C', 'F0C', 'G0C', 'H0C', 'S0C'))



----Non renewable or priority----

UPDATE fts
SET fts.DimPlanTypeId = 3
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE   (SeasonCode IN ('BB16', 'BB17') AND PriceCode IN ('TNR','TNS'))
		OR (SeasonCode = 'BB18' AND PriceCode IN ('ANP', 'BNP', 'CNP', 'DNP', 'ENP', 'FNP', 'GNP'))



---------------------Women's Basketball 2016-2017---------------------

----NEW----

UPDATE fts
SET fts.DimPlanTypeId = 1
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE   (SeasonCode = 'WB16' AND PriceCode IN ('AW9','BEO', 'BW9', 'DW9', 'EW0', 'EW9'))
		OR (SeasonCode = 'WB17' AND PriceCode IN ('CW9','DWB','EW0'))
		OR (SeasonCode = 'WB18' AND PriceCode IN ('BW9', 'CW9', 'DW9', 'EW9'))
	
		

----RENEW----

UPDATE fts
SET fts.DimPlanTypeId = 2
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE   (SeasonCode IN ('WB16', 'WB17') AND PriceCode IN ('ABS', 'AW6', 'BW2', 'BW6', 'CAD', 'CBS', 'CD2', 'CW1', 'CW6', 'DBS', 'DWA', 'DW6', 'EW2', 'EW6', 'EW7', 'FAD'))
		OR (SeasonCode = 'WB18' AND PriceCode IN ('BW1', 'BW6', 'CW1', 'CW6', 'DW1', 'DW6', 'EW1', 'EW6', 'BAD', 'CAD', 'DAD', 'EAD', 'BADF', 'CADF', 'DADF', 'EADF', 'SBS'))



----NONRENEWABLE OR PRIORITY----

UPDATE fts
SET fts.DimPlanTypeId = 3
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE   (SeasonCode = 'WB18' AND PriceCode IN ('BNP', 'DNP'))
		
		
		
----ZERO VALUE----

UPDATE fts
SET fts.DimPlanTypeId = 4
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE   (SeasonCode = 'WB16' AND PriceCode LIKE '[A-F]')
		OR (SeasonCode = 'WB17' AND PriceCode LIKE '[A-E]')
		OR (SeasonCode = 'WB18' AND PriceCode IN ('[A-G]', 'S'))



----COMP ZERO VALUE----

UPDATE fts
SET fts.DimPlanTypeId = 5
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE   (SeasonCode = 'WB16' AND PriceCode IN ('CDC', 'FDC', 'CBP', 'DBP', 'EBP'))
		OR (SeasonCode = 'WB17' AND PriceCode IN ('CBP','DBP','EBP', 'AOC'))
		OR (SeasonCode = 'WB18' AND PriceCode IN ('B0C','C0C','D0C','E0C'))



---------------------Baseball 2016---------------------

----NEW----

UPDATE fts
SET fts.DimPlanTypeId = 1
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE   (SeasonCode = 'BS16' AND PriceCode = 'AOL')
		OR (SeasonCode IN ('BS17', 'BS18') AND PriceCode = 'IOUT')
	
		

----RENEW----

UPDATE fts
SET fts.DimPlanTypeId = 2
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE   (SeasonCode = 'BS16' AND PriceCode LIKE 'A%' AND PriceCode NOT IN ('AOL','ANP','A','AC'))
		OR (SeasonCode IN ('BS17', 'BS18') AND (PriceCode LIKE '[A-M]%' OR PriceCode LIKE 'S%')
			AND PriceCode NOT IN ('A', 'ANP', 'AC') AND LEN(PriceCode) <> 1)



----Non Renewable or Priority----

UPDATE fts
SET fts.DimPlanTypeId = 3
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE   PriceCode = 'ANP'
AND		seasoncode LIKE 'BS%'



----ZERO VALUE----

UPDATE fts
SET fts.DimPlanTypeId = 4
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE   (SeasonCode = 'BS16' AND PriceCode = 'A')
		OR (SeasonCode IN ('BS17', 'BS18') AND LEN(PriceCode) = 1)



----COMP----

UPDATE fts
SET fts.DimPlanTypeId = 5
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE   PriceCode = 'AC'
AND		seasoncode LIKE 'BS%'





/*****************************************************************************************************************
													TICKET TYPE
******************************************************************************************************************/

--------------------Football--------------------

----FULL SEASON----

UPDATE fts
SET fts.DimTicketTypeId = 1
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE	ItemCode IN ('FB09','FB10','FB11','FB12','FB13','FB14','FB15','FB16','FB17', 'FB18', 'FB19', 'FB20')




----SEAT DONATION----

UPDATE fts
SET fts.DimTicketTypeId = 12
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE	ItemCode IN ('FB17SD', 'FB18SD')




----PARTIAL PLAN----

UPDATE fts
SET fts.DimTicketTypeId = 6
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	((ItemCode LIKE 'FB18-%' OR PriceCode LIKE '%FP' AND SeasonCode = 'FB18')
		OR (ItemCode LIKE 'FB17-%' OR PriceCode LIKE '%FP' AND seasoncode = 'FB17')
		OR (ItemCode LIKE 'FB16-%' OR PriceCode LIKE '%FP' AND seasoncode = 'FB16')
		OR (ItemCode LIKE 'FB15-%' OR PriceCode LIKE '%FP' AND seasoncode = 'FB15')
		OR (ItemCode LIKE 'FB14-%' OR PriceCode LIKE '%FP' AND seasoncode = 'FB14')
		OR (ItemCode LIKE 'FB13-%' OR PriceCode LIKE '%FP' AND seasoncode = 'FB13')
		OR (ItemCode LIKE 'FB12-%' OR PriceCode LIKE '%FP' AND seasoncode = 'FB12')
		OR (ItemCode LIKE 'FB11-%' OR PriceCode LIKE '%FP' AND seasoncode = 'FB11')
		OR (ItemCode LIKE 'FB10-%' OR PriceCode LIKE '%FP' AND seasoncode = 'FB10')
		OR (ItemCode LIKE 'FB09-%' OR PriceCode LIKE '%FP' AND seasoncode = 'FB09'))



----MINI PLAN----

UPDATE fts
SET fts.DimTicketTypeId = 2
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimPlan dp ON fts.DimPlanId = dp.DimPlanId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	PriceCode.PriceCode LIKE '%EXP' OR PriceCode.PriceCode IN ('2FM', '2FP', '4FM', '4FP', '5FM', '5FP')





----SINGLE GAME----

UPDATE fts
SET fts.DimTicketTypeId = 3
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.DimPriceCode pc ON fts.dimpricecodeid = pc.DimPriceCodeId
WHERE	ItemCode LIKE 'FB%' AND LEN(ItemCode) = 8 AND PriceCode NOT LIKE '%FP'
AND		SeasonCode LIKE 'FB%'



----SINGLE GAME PUBLIC - All Sports----

UPDATE fts
SET fts.DimTicketTypeId = 14
FROM #stgFactTicketSales fts
JOIN dbo.DimPriceCode pc (NOLOCK)
	ON fts.DimPriceCodeId = pc.DimPriceCodeId
JOIN dbo.DimEvent e (NOLOCK)
	ON fts.DimEventId = e.DimEventId
JOIN dbo.DimEventHeader eh (NOLOCK)
	ON eh.DimEventHeaderId = e.DimEventHeaderId
JOIN dbo.DimSeasonHeader sh (NOLOCK)
	ON eh.DimSeasonHeaderId = sh.DimSeasonHeaderId
WHERE (eh.DimSeasonHeaderId IN (3, 10, 16, 22)
		AND pc.PriceCode IN ('1', '2', '4', '5', 'A', 'B', 'C', 'D', 'G', 'H', 'J', 'K')
		AND fts.IsHost = 1)
	OR (sh.DimSeasonHeaderID IN (2, 9, 15, 21)
		AND LEN(pc.PriceCode) = 1)



---- SINGLE GAME ARCHTICS - All sports----
UPDATE fts
SET fts.DimTicketTypeId = 15
FROM #stgFactTicketSales fts
JOIN dbo.DimPriceCode pc (NOLOCK)
	ON fts.DimPriceCodeId = pc.DimPriceCodeId
JOIN dbo.DimEvent e (NOLOCK)
	ON fts.DimEventId = e.DimEventId
JOIN dbo.DimEventHeader eh (NOLOCK)
	ON eh.DimEventHeaderId = e.DimEventHeaderId
JOIN dbo.DimSeasonHeader sh (NOLOCK)
	ON eh.DimSeasonHeaderId = sh.DimSeasonHeaderId
WHERE (eh.DimSeasonHeaderId IN (2, 9, 15, 21)
			AND pc.PriceCode IN ('CEU','DSU','EWU','AP'))
		OR (eh.DimSeasonHeaderId IN (10)
			AND pc.PriceCode IN ('ABL', 'AIMG', 'BBM'))
		OR (eh.DimSeasonHeaderId IN (3, 10, 16, 22)
			AND pc.PriceCode IN ('2PP', '1LG', '1LP', '1TV', '2FM', '2UG', '2UP', '2WS', '4FM', '5FM', 'APW'))




----SINGLE GAME Visitor - All Sports----
UPDATE fts
SET fts.DimTicketTypeId = 16
FROM #stgFactTicketSales fts
JOIN dbo.DimPriceCode pc (NOLOCK)
	ON fts.DimPriceCodeId = pc.DimPriceCodeId
JOIN dbo.DimEvent e (NOLOCK)
	ON fts.DimEventId = e.DimEventId
JOIN dbo.DimEventHeader eh (NOLOCK)
	ON eh.DimEventHeaderId = e.DimEventHeaderId
JOIN dbo.DimSeasonHeader sh (NOLOCK)
	ON eh.DimSeasonHeaderId = sh.DimSeasonHeaderId
WHERE (eh.DimSeasonHeaderId IN (3, 10, 16, 22, 306, 370)
		AND fts.SSID_acct_id IN (
			SELECT DISTINCT v.ArchticsID
			FROM dbo.VisitingTeamArchticsAccounts v (NOLOCK)
			)
		)
	OR (sh.DimSeasonHeaderID IN (2, 9, 15, 21, 50, 82, 314, 321, 327)
		AND pc.PriceCode = 'AVIS')



----Single Game Walk-Up----
UPDATE fts
SET fts.DimTicketTypeId = 17
FROM #stgFactTicketSales fts (NOLOCK)
JOIN dbo.DimEvent e (NOLOCK)
	ON fts.DimEventId = e.DimEventId
JOIN dbo.DimDate dd (NOLOCK)
	ON fts.DimDateId_OrigSale = dd.DimDateId
WHERE TotalRevenue > 0
	AND dd.CalDate = e.EventDate




----GROUP----

UPDATE fts
SET fts.DimTicketTypeId = 4
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	(SeasonCode = 'FB16' AND PriceCode IN ('1GRP', '1SFS', '2SCD','3YSD','2TAD','AGRP', '1GRO'))
		OR (SeasonCode IN ('FB17', 'FB18') AND PriceCode IN ('2FFD', '2IG', '2G', '2TAD', '2SCD', '2YSD'))



----SEAT PREMIUM----

UPDATE fts
SET fts.DimTicketTypeId = 13
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE	ItemCode IN ('FB17SP', 'FB18SP')


------Student Upper Level Football --------
UPDATE fts
SET fts.DimTicketTypeId = 18
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	PriceCode = 'BSTU'




--------------------Men's Basketball 2016-2017--------------------

----FULL SEASON----

UPDATE fts
SET fts.DimTicketTypeId = 1
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	ItemCode IN ('BB14', 'BB15', 'BB16', 'BB17', 'BB18', 'BB19', 'BB20')
AND		SeasonCode LIKE 'BB%'



----MOBILE SEASON TICKET----

UPDATE fts
SET fts.DimTicketTypeId = 5
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	ItemCode IN ('BB16MOB', 'BB17MOB', 'BB18MOB')
AND		SeasonCode LIKE 'BB%'



----PARTIAL SEASON----

UPDATE fts
SET fts.DimTicketTypeId = 6
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(ItemCode LIKE 'BB16-%' OR ItemCode LIKE 'BB17-%' OR ItemCode = 'BB15SAT' OR ItemCode LIKE 'BB18-%')
AND		SeasonCode LIKE 'BB%'



----FLEX PLAN----

UPDATE fts
SET fts.DimTicketTypeId = 7
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	ItemCode IN ('BB14FLEX','BB15FLEX','BB16FLEX','BB17FLEX', 'BB18FLEX', 'BB19FLEX', 'BB20FLEX')
AND		SeasonCode LIKE 'BB%'



----SINGLE GAME----

UPDATE fts
SET fts.DimTicketTypeId = 3
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	LEN(ItemCode) = 8 AND (ItemCode LIKE 'BB16%' OR Itemcode LIKE 'BB17%' OR ItemCode LIKE 'BB18%')
AND		PriceCode <> 'DBN'
AND		SeasonCode LIKE 'BB%'


----Students----

UPDATE fts
SET fts.DimTicketTypeId = 19
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		INNER JOIN dbo.DimSeason season ON season.DimSeasonId = fts.dimseasonid
WHERE	PriceCode = 'ZST' AND season.SeasonName LIKE '%Gamecock Men''s Basketball'


----GROUP----

UPDATE fts
SET fts.DimTicketTypeId = 4
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	LEN(ItemCode) = 8 AND (ItemCode LIKE 'BB16%' OR Itemcode LIKE 'BB17%' OR ItemCode LIKE 'BB18%')
AND		PriceCode = 'DBN'
AND		SeasonCode LIKE 'BB%'



--------------------Women's Basketball 2016-2017--------------------

----FULL SEASON----

UPDATE fts
SET fts.DimTicketTypeId = 1
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	ItemCode IN ('WB13','WB14','WB15','WB16','WB17', 'WB18', 'WB19', 'WB20')
AND		seasoncode LIKE 'WB%'



----SINGLE GAME----

UPDATE fts
SET fts.DimTicketTypeId = 3
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	LEN(ItemCode) = 8 AND (ItemCode LIKE 'WB16%' OR ItemCode LIKE 'WB17%' OR ItemCode LIKE 'WB18%')
AND		seasoncode LIKE 'WB%'




----POSTSEASON SEASON TICKET----

UPDATE fts
SET fts.DimTicketTypeId = 8
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	ItemCode IN ('WB15ASB','WB16ASB', 'WB17ASB', 'WB18ASB')
AND		seasoncode LIKE 'WB%'




----POSTSEASON SINGLE GAME----

UPDATE fts
SET fts.DimTicketTypeId = 9
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	ItemCode IN ('WB18R1', 'WB18R2', 'WB17R1', 'WB18R2', 'WB16R1', 'WB16R2', 'WB15R1', 'WB15R2')
AND		seasoncode LIKE 'WB%'




----TSHIRT PACKAGE----

UPDATE fts
SET fts.DimTicketTypeId = 10
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	ItemCode IN ('WB16CLUB','WB17CLUB', 'WB18CLUB')
AND		seasoncode LIKE 'WB%'



--------------------Baseball 2016--------------------

----FULL SEASON----

UPDATE fts
SET fts.DimTicketTypeId = 1
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	ItemCode IN ('BS13','BS14','BS15','BS16','BS17', 'BS18', 'BS19', 'BS20')
AND		Seasoncode LIKE 'BS%'



----Mini Plan----

UPDATE fts
SET fts.DimTicketTypeId = 2
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON fts.dimplanid = p.DimPlanId
WHERE	PlanCode IN ('BS16FRIM','BS16SATM', 'BS16SUNM')
AND		Seasoncode = 'BS16'




----SINGLE GAME----

UPDATE fts
SET fts.DimTicketTypeId = 3
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	ItemCode LIKE 'BS%' AND LEN(ItemCode) >= 8
AND		Seasoncode LIKE 'BS%'



----PARKING----

UPDATE fts
SET fts.DimTicketTypeId = 11
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	ItemCode LIKE 'BS%PK' AND LEN(ItemCode) = 6
AND		Seasoncode LIKE 'BS%'



----SEAT DONATIONS----

UPDATE fts
SET fts.DimTicketTypeId = 12
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	ItemCode LIKE 'BS%SD' AND LEN(ItemCode) = 6
AND		Seasoncode LIKE 'BS%'



----SEAT PREMIUM----

UPDATE fts
SET fts.DimTicketTypeId = 13
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	ItemCode LIKE 'BS%SP' AND LEN(ItemCode) = 6
AND		Seasoncode LIKE 'BS%'



----POSTSEASON SEASON PACKAGE----

UPDATE fts
SET fts.DimTicketTypeId = 8
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	ItemCode LIKE 'BS%' AND (ItemCode LIKE '%REG' OR ItemCode LIKE '%SREG') AND (LEN(ItemCode) = 7 OR LEN(ItemCode) = 8)
AND		Seasoncode LIKE 'BS%'



----POSTSEASON SINGLE GAME----

UPDATE fts
SET fts.DimTicketTypeId = 9
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	ItemCode LIKE 'BS%R[1-20]'
AND		Seasoncode LIKE 'BS%'



	

/*****************************************************************************************************************
													TICKET CLASS
******************************************************************************************************************/

---------------------Football 2016---------------------

----FULL SEASON NEW ADULT----

UPDATE fts
SET fts.DimTicketClassId = 1
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode IN ('FB15', 'FB16') AND DimTicketTypeid = 1 AND DimPlanTypeId = 1 AND PriceCode LIKE '[F-L]%[[A-G]')
		OR (SeasonCode IN ('FB17', 'FB18') AND PriceCode = '1IBN')


----FULL SEASON NEW FACULTY----

UPDATE fts
SET fts.DimTicketClassId = 2
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeId = 1 AND dimplantypeid = 1 AND (
			(SeasonCode = 'FB15' AND PriceCode LIKE '[M-S]%[M-S]')
			OR (SeasonCode = 'FB16' AND PriceCode LIKE '[M-S]4%')
			OR (SeasonCode IN ('FB17', 'FB18') AND PriceCode = '1IFN')
			)



----FULL SEASON NEW YOUNG ALUMNI----

UPDATE fts
SET fts.DimTicketClassId = 3
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeId = 1 AND Pricecode IN ('KINR','KYA1','KYI1','LINR','LYI1')
AND		seasoncode LIKE 'FB%'



----FULL SEASON RENEWAL ADULT----

UPDATE fts
SET fts.DimTicketClassId = 4
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode IN ('FB15', 'FB16') AND DimTicketTypeid = 1 AND DimPlanTypeid = 2 AND PriceCode LIKE '[A-L]%')
		OR (SeasonCode IN ('FB17', 'FB18') AND (PriceCode = '1IBR' OR PriceCode LIKE '1%B'))



----FULL SEASON RENEWAL FACULTY----

UPDATE fts
SET fts.DimTicketClassId = 5
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode IN ('FB15', 'FB16') AND DimTicketTypeid = 1 AND dimplantypeid = 2 AND PriceCode LIKE '[M-S]%')
		OR (SeasonCode IN ('FB17', 'FB18') AND (PriceCode = '1IFR' OR PriceCode LIKE '1%B'))



----FULL SEASON RENEWAL YOUNG ALUMNI----

UPDATE fts
SET fts.DimTicketClassId = 74
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	SeasonCode IN ('FB17', 'FB18') AND PriceCode IN ('KYA2', 'KYI2')



----FULL SEASON RENEWAL SUITE----

UPDATE fts
SET fts.DimTicketClassId = 75
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	SeasonCode IN ('FB17', 'FB18') AND PriceCode IN ('SSTE')



----FULL SEASON RENEWAL LIFETIME----

UPDATE fts
SET fts.DimTicketClassId = 76
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	SeasonCode IN ('FB17', 'FB18') AND PriceCode LIKE '[E-K]%LT'



----FULL SEASON NON RENEWABLE OR PRIORITY ADULT----

UPDATE fts
SET fts.DimTicketClassId = 6
FROM    #stgFactTicketSales fts
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeid = 1 AND dimplantypeid = 3
AND		seasoncode LIKE 'FB%'



----FULL SEASON NON RENEWABLE OR PRIORITY YOUNG ALUMNI----

UPDATE fts
SET fts.DimTicketClassId = 7
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 1 AND PriceCode IN ('KYNR','LYNR')
AND		seasoncode LIKE 'FB%'



----MINI PLAN----

UPDATE fts
SET fts.DimTicketClassId = 8
FROM    #stgFactTicketSales fts
		JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode IN ('FB15', 'FB16') AND DimTicketTypeid = 2)
		OR (SeasonCode IN ('FB17', 'FB18') AND (PriceCode LIKE '2%' OR PriceCode LIKE '[4-5]%') AND (PriceCode LIKE '%FP' OR PriceCode LIKE '%FM'))



----SINGLE GAME FULL PRICE----

UPDATE fts
SET fts.DimTicketClassId = 9
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	SeasonCode IN ('FB15', 'FB16') AND DimTicketTypeid IN (3, 14, 15, 16, 17) AND PriceCode IN ('AP','AVIS','CEU','DSU','EWU','FLS','GR2')



----SINGLE GAME PRE SALE LOWER LEVEL----

UPDATE fts
SET fts.DimTicketClassId = 77
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	SeasonCode IN ('FB17', 'FB18') AND PriceCode IN ('1LG', '1TV')



----SINGLE GAME PRE SALE UPPER LEVEL----

UPDATE fts
SET fts.DimTicketClassId = 78
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	SeasonCode IN ('FB17', 'FB18') AND PriceCode = '2UG'



----SINGLE GAME PUBLIC LOWER LEVEL----

UPDATE fts
SET fts.DimTicketClassId = 79
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	SeasonCode IN ('FB17', 'FB18') AND PriceCode IN ('1LP')



----SINGLE GAME PRE SALE LOWER LEVEL----

UPDATE fts
SET fts.DimTicketClassId = 80
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	SeasonCode IN ('FB17', 'FB18') AND PriceCode = '2UP'



----SINGLE GAME ZERO VALUE----

UPDATE fts
SET fts.DimTicketClassId = 10
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	LEN(PriceCode) = 1
AND		seasoncode LIKE 'FB%'




----SINGLE GAME COMP----

UPDATE fts
SET fts.DimTicketClassId = 11
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeid IN (3, 14, 15, 16, 17) AND PriceCode IN ('A0C','T0C')
AND		seasoncode LIKE 'FB%'



----GROUP FULL PRICE----

UPDATE fts
SET fts.DimTicketClassId = 12
FROM    #stgFactTicketSales fts
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 4
AND		seasoncode LIKE 'FB%'


----SEAT DONATION----

UPDATE fts
SET fts.DimTicketClassId = 59
FROM    #stgFactTicketSales fts
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 12
AND		seasoncode LIKE 'FB%'



----SEAT PREMIUM----

UPDATE fts
SET fts.DimTicketClassId = 62
FROM    #stgFactTicketSales fts
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 13
AND		seasoncode LIKE 'FB%'



---------------------Men's Basketball 2016-2017---------------------

----FULL SEASON NEW ADULT----

UPDATE fts
SET fts.DimTicketClassId = 1
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeiD = 1
		AND (
			(SeasonCode = 'BB16' AND PriceCode IN ('GMA','HMB','JME','KMF','IMC', 'TMD'))
			OR (SeasonCode = 'BB17' AND PriceCode IN ('GMA','HMB','JME','KMF','IMC'))
			OR (SeasonCode = 'BB18' AND PriceCode IN ('AMA', 'BMA', 'CMB', 'EMC', 'DME', 'FMF', 'GMC', 'HJY'))
			)



----FULL SEASON NEW FACULTY----

UPDATE fts
SET fts.DimTicketClassId = 2
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeid = 1
		AND ((SeasonCode IN ('BB16', 'BB17') AND PriceCode IN ('MMG','NMH'))
		OR (SeasonCode = 'BB18' AND PriceCode IN ('CMG', 'DMH')))



----FULL SEASON RENEWAL ADULT----

UPDATE fts
SET fts.DimTicketClassId = 4
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeId = 1
		AND (
			(SeasonCode = 'BB16' AND PriceCode IN ('GIA', 'GBA', 'HIB', 'HBB', 'HMT', 'IBC', 'IIC', 'JIE', 'KIF', 'TID', 'IMT', 'JBD', 'JMT', 'KBE', 'KMT', 'TBT'))
			OR (SeasonCode = 'BB17' AND Pricecode IN ('GIA','GBA','HIB','HBB','JIE','KIF','JBD','KBE','KMT','SBS','II','IBC'))
			OR (SeasonCode = 'BB18' AND PriceCode IN ('AFC', 'AIA', 'BFC', 'BIA', 'CBB', 'CIB', 'EBC', 'EIC', 'DBD', 'DIE', 'DBE', 'FIF', 'GBC', 'GIC', 'HJY2'))
			)



----FULL SEASON RENEWAL FACULTY----

UPDATE fts
SET fts.DimTicketClassId = 5
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeid = 1
		AND ((SeasonCode IN ('BB16', 'BB17') AND PriceCode IN ('MIG','NIH','NBI','MBH'))
		OR (SeasonCode = 'BB18' AND PriceCode IN ('CBH', 'CIG', 'DIH', 'DBI')))



----FULL SEASON RENEWAL CAR DEALER----

UPDATE fts
SET fts.DimTicketClassId = 13
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeid = 1 AND PriceCode IN ('RAD','RAD1')
AND		SeasonCode LIKE 'BB%'



----FULL SEASON NON RENEWABLE OR PRIORITY----

UPDATE fts
SET fts.DimTicketClassId = 6
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeid = 1
		AND ((SeasonCode IN ('BB16', 'BB17') AND PriceCode IN ('TNR','TNS'))
		OR (SeasonCode = 'BB18' AND PriceCode IN ('ANP', 'BNP', 'CNP', 'DNP', 'ENP', 'FNP', 'GNP')))



----FULL SEASON COMP----

UPDATE fts
SET fts.DimTicketClassId = 14
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 1
		AND ((SeasonCode IN ('BB16', 'BB17') AND PriceCode = 'QBP')
		OR (SeasonCode = 'BB18' AND PriceCode IN ('AOC', 'BOC', 'COC', 'DOC', 'EOC', 'FOC', 'GOC', 'HOC')))



----SINGLE GAME ZERO VALUE----

UPDATE fts
SET fts.DimTicketClassId = 10
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	PriceCode LIKE '[A-Z]'
AND		SeasonCode LIKE 'BB%'



----SINGLE GAME FULL PRICE ADULT----

UPDATE fts
SET fts.DimTicketClassId = 9
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode = 'BB16' AND PriceCode IN ('BBL', 'BIMG', 'CBM'))
		OR (SeasonCode = 'BB17' AND PriceCode IN ('BBL','AP'))
		OR (SeasonCode = 'BB18' AND PriceCode IN ('ABL', 'AP', 'BBM'))




----SINGLE GAME FULL PRICE BILO----

UPDATE fts
SET fts.DimTicketClassId = 15
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	PriceCode IN ('BILO')
AND		SeasonCode LIKE 'BB%'




----SINGLE GAME FULL PRICE STUDENT----

UPDATE fts
SET fts.DimTicketClassId = 16
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	PriceCode IN ('BSTL')
AND		SeasonCode LIKE 'BB%'



----SINGLE GAME FULL PRICE EXPERIENCE----

UPDATE fts
SET fts.DimTicketClassId = 17
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		JOIN dbo.dimplan p ON p.DimPlanId = fts.DimPlanId
WHERE	PriceCode IN ('AEXP', 'BEXP')
AND		SeasonCode LIKE 'BB%'



----GROUP----

UPDATE fts
SET fts.DimTicketClassId = 12
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode = 'BB16' AND PriceCode = 'DBN')
		OR (SeasonCode = 'BB17' AND PriceCode IN ('DBN', 'DANC'))
		OR (SeasonCode = 'BB18' AND PriceCode IN ('DBN', 'DANC', 'DBC'))



----MINI PLAN----

UPDATE fts
SET fts.DimTicketClassId = 8
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode = 'BB16' AND PriceCode IN ('A02', 'A04', 'B01', 'B03'))
		OR (SeasonCode = 'BB17' AND PriceCode IN ('ETS'))



----SINGLE GAME COMP VALUE ADULT----

UPDATE fts
SET fts.DimTicketClassId = 11
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode = 'BB17' AND PriceCode IN ('FBP','TMC'))
		OR (SeasonCode = 'BB18' AND PriceCode IN ('FBP', 'AOC', 'BOC', 'TMC'))



----SINGLE GAME COMP VALUE STUDENT----

UPDATE fts
SET fts.DimTicketClassId = 18
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode = 'BB16' AND PriceCode IN ('BSTL', 'ZSBG'))
		OR (SeasonCode IN ('BB17', 'BB18') AND PriceCode = 'ZST')



---------------------Women's Basketball 2016-2017---------------------

----FULL SEASON NEW GENERAL ADMISSION----

UPDATE fts
SET fts.DimTicketClassId = 19
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 1 AND (
			(SeasonCode = 'WB16' AND PriceCode IN ('EW0', 'BW0'))
			OR (SeasonCode = 'WB17' AND PriceCode IN ('EW0'))
			OR (SeasonCode = 'WB18' AND PriceCode = 'EW9')
		)



----FULL SEASON NEW CORNER RESERVED----

UPDATE fts
SET fts.DimTicketClassId = 20
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 1 AND (
		(SeasonCode IN ('WB16', 'WB17') AND PriceCode IN ('DWB'))
		OR (SeasonCode = 'WB18' AND PriceCode = 'CW9')
		)



----FULL SEASON NEW BASELINE RESERVED----

UPDATE fts
SET fts.DimTicketClassId = 81
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode = 'WB18' AND DimTicketTypeID = 1 AND PriceCode = 'DW9')



----FULL SEASON NEW RESERVED----

UPDATE fts
SET fts.DimTicketClassId = 21
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 1 AND (
			(SeasonCode = 'WB16' AND PriceCode IN ('AW9', 'BW9', 'DW9', 'EW9'))
			OR (SeasonCode = 'WB17' AND PriceCode IN ('CW9'))
			OR (SeasonCode = 'WB18' AND PriceCode IN ('BW09'))
		)



----FULL SEASON NEW ----

UPDATE fts
SET fts.DimTicketClassId = 1
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 1 AND DimPlanTypeID = 1 AND (
			(SeasonCode = 'WB16' AND PriceCode LIKE '[A-F]')
			OR (SeasonCode = 'WB17' AND PriceCode LIKE '[A-E]')
			OR (SeasonCode = 'WB18' AND PriceCode IN ('[A-G', 'S'))
		)



----FULL SEASON RENEWAL GENERAL ADMISSION----

UPDATE fts
SET fts.DimTicketClassId = 22
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 1 AND (
			(SeasonCode = 'WB16' AND PRiceCode IN ('BW7', 'EW7'))
			OR (SeasonCode = 'WB17' AND PriceCode IN ('EW2','EW7','ED2','EBP'))
			OR (SeasonCode = 'WB18' AND PriceCode IN ('EADF', 'EW1', 'EW6'))
		)



----FULL SEASON RENEWAL CORNER RESERVED----

UPDATE fts
SET fts.DimTicketClassId = 23
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 1 AND (
		(SeasonCode IN ('WB16', 'WB17') AND PriceCode IN ('DWA','DD2','DBP'))
		OR (SeasonCode = 'WB18' AND PriceCode IN ('CADF', 'CRS', 'CW1', 'CW6'))
		)



----FULL SEASON RENEWAL RESERVED----

UPDATE fts
SET fts.DimTicketClassId = 24
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 1 AND (
			(SeasonCode = 'WB16' AND PriceCode IN ('BW6', 'DW6', 'EW6'))
			OR (SeasonCode = 'WB17' AND PriceCode IN ('CD2','CW1','CW6','CBP','CBS'))
			OR (SeasonCode = 'WB18' AND PriceCode IN ('BADF', 'BW1', 'BW6'))
		)



---- FULL SEASON RENEWAL CAR DEALER----
UPDATE fts
SET fts.DimTicketClassId = 13
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 1 AND (
			(SeasonCode = 'WB18' AND PriceCode IN ('BAD', 'CAD', 'DAD', 'EAD'))
		)



---- FULL SEASON RENEWAL SUITE----
UPDATE fts
SET fts.DimTicketClassId = 75
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 1 AND (
			(SeasonCode = 'WB18' AND PriceCode = 'SBS')
		)



----FULL SEASON RENEWAL----

UPDATE fts
SET fts.DimTicketClassId = 4
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 1 AND DimPlanTypeID = 2 AND (
			(SeasonCode = 'WB16' AND PriceCode LIKE '[A-F]')
			OR (SeasonCode IN ('WB17', 'WB18') AND PriceCode LIKE '[A-E]')
		)



----SINGLE GAME GENERAL ADMISSION----

UPDATE fts
SET fts.DimTicketClassId = 25
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID IN (3, 14, 15, 16, 17) AND (
			(SeasonCode = 'WB16' AND PriceCode IN ('AW3', 'AW4', 'AW5'))
			OR (SeasonCode = 'WB17' AND PriceCode IN ('AW3','ED2','EW0','EW2','EW7','BW5','AW4'))
			OR (SeasonCode = 'WB18' AND PriceCode IN ('AW3', 'AW4', 'BW5'))
		)



----SINGLE GAME CORNER RESERVED----

UPDATE fts
SET fts.DimTicketClassId = 26
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 3 AND (
		(SeasonCode IN ('WB16', 'WB17') AND PriceCode IN ('DD2','DWA','DBP'))
		)




----SINGLE GAME RESERVED----

UPDATE fts
SET fts.DimTicketClassId = 27
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID IN (3, 14, 15, 16, 17) AND (
			(SeasonCode = 'WB17' AND PriceCode IN ('CW9','CW6','CW1','CRR','CD2'))
			OR (SeasonCode = 'WB18' AND PriceCode IN ('CRS', 'RBRS', 'RRBC'))
			)



----SINGLE GAME COMP----

UPDATE fts
SET fts.DimTicketClassId = 18
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID IN (3, 14, 15, 16, 17) AND (
			(SeasonCode = 'WB17' AND PriceCode IN ('DBP','CBP','EBP'))
			OR (SeasonCode = 'WB18' AND PriceCode = 'FBP')
		)



----SINGLE GAME SUITE----

UPDATE fts
SET fts.DimTicketClassId = 28
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID IN (3, 14, 15, 16, 17) AND (
			(SeasonCode = 'WB16' AND PriceCode = 'ASTE')
			OR (SeasonCode = 'WB17' AND PriceCode IN ('FES','FST','CBS'))
			OR (SeasonCode = 'WB18' AND PriceCode = 'SSG')
		)



----SINGLE GAME STUDENT----

UPDATE fts
SET fts.DimTicketClassId = 16
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID IN (3, 14, 15, 16, 17) AND (
			(SeasonCode = 'WB16' AND PriceCode = 'BST')
			OR (SeasonCode IN ('WB17', 'WB18') AND PriceCode IN ('ZST'))
		)



----SINGLE GAME EXPERIENCE----

UPDATE fts
SET fts.DimTicketClassId = 17
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID IN (3, 14, 15, 16, 17) AND PriceCode IN ('AEXP')
AND		seasoncode IN ('WB17', 'WB18')



----SINGLE GAME----

UPDATE fts
SET fts.DimTicketClassId = 9
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID IN (3, 14, 15, 16, 17) AND PriceCode IN ('A','B','C','D','E','F','G','R','S','Z')
AND		seasoncode LIKE 'WB%'



----POSTSEASON SEASON TICKET RESERVED----

UPDATE fts
SET fts.DimTicketClassId = 29
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 8 AND (
			(SeasonCode = 'WB16' AND PriceCode IN ('AX1','BX3', 'CSS'))
			OR (SeasonCode IN ('WB17', 'WB18') AND PriceCode IN ('AX1','AX3'))
		)



----POSTSEASON SEASON TICKET BASELINE RESERVED----

UPDATE fts
SET fts.DimTicketClassId = 30
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 8 AND (
			(SeasonCode = 'WB17' AND PriceCode IN ('BX5','BX6'))
			OR (SeasonCode = 'WB18' AND PriceCode IN ('BX5', 'BX6', 'EX1', 'EX5'))
		)



----POSTSEASON SEASON TICKET SUITE----

UPDATE fts
SET fts.DimTicketClassId = 31
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 8 AND PriceCode IN ('CCS','DBS')
AND		seasoncode IN ('WB17', 'WB18')



----POSTSEASON SEASON TICKET GENERAL ADMISSION----

UPDATE fts
SET fts.DimTicketClassId = 32
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 8 AND (
			(SeasonCode = 'WB16' AND PriceCode IN ('AX0', 'BS2'))
			OR (SeasonCode IN ('WB17', 'WB18') AND PriceCode IN ('CX0','CX2'))
		)



----POSTSEASON SEASON TICKET----

UPDATE fts
SET fts.DimTicketClassId = 40
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 8 AND PriceCode IN ('A','B','C','D', 'E')
AND		seasoncode LIKE 'WB%'



----POSTSEASON SINGLE GAME RESERVED----

UPDATE fts
SET fts.DimTicketClassId = 34
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 9 AND PriceCode IN ('ARR','BRR','CRR','DRR')
AND		seasoncode LIKE 'WB17'



----POSTSEASON SINGLE GAME GENERAL ADMISSION----

UPDATE fts
SET fts.DimTicketClassId = 37
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 9 AND (
			(SeasonCode = 'WB16' AND PriceCode IN ('AAS', 'ARS', 'ARS2'))
			OR (SeasonCode = 'WB17' AND PriceCode IN ('AW3','BW4','DWF','CAG'))
		)



----POSTSEASON SINGLE GAME STUDENT----

UPDATE fts
SET fts.DimTicketClassId = 38
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 9 AND (
			(SeasonCode = 'WB16' AND PriceCode IN ('AW3', 'AW4', 'AW5', 'AWF', 'DST2'))
			OR (SeasonCode = 'WB17' AND PriceCode = 'ZBG')
		)



----POSTSEASON SINGLE GAME----

UPDATE fts
SET fts.DimTicketClassId = 39
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 9 AND PriceCode IN ('A','B','C','D','Z')
AND		seasoncode = 'WB17'



----TSHIRT PLAN ADULT----

UPDATE fts
SET fts.DimTicketClassId = 41
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 10 AND PriceCode IN ('AUO','BU1','CU2','DU3','EU4','FU5')
AND		seasoncode IN ('WB17', 'WB18')



----TSHIRT PLAN YOUTH----

UPDATE fts
SET fts.DimTicketClassId = 42
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 10 AND PriceCode IN ('GU7','HU8','IU9')
AND		seasoncode IN ('WB17', 'WB18')



----TSHIRT PLAN----

UPDATE fts
SET fts.DimTicketClassId = 43
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 10 AND PriceCode IN ('A','B','C','D','E','F','G','H','I') 
AND		seasoncode IN ('WB17', 'WB18')



---------------------Baseball 2016---------------------

----FULL SEASON NEW ADULT----

UPDATE fts
SET fts.DimTicketClassId = 1
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode = 'BS16' AND DimTicketTypeid = 1 AND PriceCode = 'AOL')
		OR (SeasonCode IN ('BS17', 'BS18') AND DimTicketTypeID = 1 AND PriceCode = 'IOUT')



----FULL SEASON ZERO VALUE----

UPDATE fts
SET fts.DimTicketClassId = 14
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode IN ('BS16', 'BS17', 'BS18') AND DimTicketTypeId = 1 AND PriceCode = 'A')



----FULL SEASON RENEWAL ADULT----

UPDATE fts
SET fts.DimTicketClassId = 4
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode = 'BS16' AND DimTicketTypeId = 1 AND Pricecode IN ('ABX','AR','ACL','AGA','AND','APS','APTA','ASU'))
		OR (SeasonCode IN ('BS17') AND DimTicketTypeID = 1 AND PriceCode IN ('AGA', 'ALT', 'ASU'))



----FULL SEASON RENEWAL FACULTY----

UPDATE fts
SET fts.DimTicketClassId = 5
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode IN ('BS16') AND DimTicketTypeid = 1 AND PriceCode IN ('AF','AF02','AFND'))
		OR (SeasonCode IN ('BS17', 'BS18') AND DimTicketTypeid = 1 AND PriceCode IN ('AF','AFSC'))



----FULL SEASON RENEWAL SENIOR----

UPDATE fts
SET fts.DimTicketClassId = 44
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode = 'BS16' AND DimTicketTypeid = 1 AND PriceCode IN ('ASC','ASCN'))
		OR (SeasonCode IN ('BS17','BS18') AND DimTicketTypeID = 1 AND PriceCode IN ('ALT2', 'ASC'))



----FULL SEASON RENEWAL CAR DEALER----

UPDATE fts
SET fts.DimTicketClassId = 13
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode = 'BS16' AND DimTicketTypeid = 1 AND PriceCode IN ('AD','AD2'))
		OR (SeasonCode IN ('BS17', 'BS18') AND DimTicketTypeid = 1 AND PriceCode IN ('AAD','AD2'))



----FULL SEASON RENEWAL COMP----

UPDATE fts
SET fts.DimTicketClassId = 71
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 1 AND PriceCode = 'AC'
AND		seasoncode LIKE 'BS%'



----FULL SEASON RENEWAL NON PRIORITY----

UPDATE fts
SET fts.DimTicketClassId = 45
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeid = 1 AND PriceCode = 'ANP'
AND		seasoncode LIKE 'BS%'



----SINGLE GAME ADULT----

UPDATE fts
SET fts.DimTicketClassId = 9
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode = 'BS16' AND DimTicketTypeid = 3 AND PriceCode IN ('ABX','ACL','AND','AOL','APS','AR','ASC','ASCN','ASU','BRS','AD2','APTA'))
		OR (SeasonCode IN ('BS17', 'BS18') AND DimTicketTypeid IN (3, 14, 15, 16, 17) AND PriceCode IN ('AGA', 'AR', 'ASC', 'ASU', 'BRS'))


----SINGLE GAME FACULTY----

UPDATE fts
SET fts.DimTicketClassId = 47
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode = 'BS16' AND DimTickettypeID IN (3, 14, 15, 16, 17) AND PriceCode IN ('AF','AF02','AFND'))
		OR (SeasonCode IN ('BS17', 'BS18') AND DimTickettypeID IN (3, 14, 15, 16, 17) AND PriceCode IN ('AF','AFSC','AFND'))




----SINGLE GAME YOUTH----

UPDATE fts
SET fts.DimTicketClassId = 48
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTickettypeID IN (3, 14, 15, 16, 17) AND PriceCode IN ('AIY')
AND		seasoncode LIKE 'BS%'



----SINGLE GAME NON RENEWABLE OR PRIORITY----

UPDATE fts
SET fts.DimTicketClassId = 72
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTickettypeID IN (3, 14, 15, 16, 17) AND PriceCode IN ('ANP')
AND		seasoncode LIKE 'BS%'



----SINGLE GAME COMP----

UPDATE fts
SET fts.DimTicketClassId = 11
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTickettypeID IN (3, 14, 15, 16, 17) AND PriceCode IN ('ACOF','ASCR','AC','AD', 'AEXC')
AND		seasoncode LIKE 'BS%'



----SINGLE GAME BILO----

UPDATE fts
SET fts.DimTicketClassId = 15
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTickettypeID IN (3, 14, 15, 16, 17) AND PriceCode IN ('BLOF','BLOS')
AND		seasoncode LIKE 'BS%'



----SINGLE GAME BLEACHER----

UPDATE fts
SET fts.DimTicketClassId = 49
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTickettypeID IN (3, 14, 15, 16, 17) AND PriceCode IN ('COF')
AND		seasoncode LIKE 'BS%'



----SINGLE GAME STANDING ROOM----

UPDATE fts
SET fts.DimTicketClassId = 50
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTickettypeID IN (3, 14, 15, 16, 17) AND PriceCode IN ('DSR','AGA')
AND		seasoncode LIKE 'BS%'



----SINGLE GAME STUDENT----

UPDATE fts
SET fts.DimTicketClassId = 16
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTickettypeID IN (3, 14, 15, 16, 17) AND PriceCode IN ('ZSBG')
AND		seasoncode LIKE 'BS%'



----SINGLE GAME EXPERIENCE----

UPDATE fts
SET fts.DimTicketClassId = 17
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTickettypeID IN (3, 14, 15, 16, 17) AND PriceCode IN ('AEXP', 'BEXP', 'CEXP', 'DEXP')
AND		seasoncode LIKE 'BS%'



----SINGLE GAME----

UPDATE fts
SET fts.DimTicketClassId = 73
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTickettypeID IN (3, 14, 15, 16, 17) AND PriceCode IN ('A','B','C','D','Z')
AND		seasoncode LIKE 'BS%'



----GROUP ADULT----

UPDATE fts
SET fts.DimTicketClassId = 51
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode IN ('BS16') AND DimTicketTypeID = 4 AND PriceCode IN ('AGR','AGSR'))
		OR (SeasonCode IN ('BS17', 'BS18') AND DimTicketTypeID = 4 AND PriceCode IN ('AGR', 'AGSR', 'AGRP'))



----GROUP TAILGATE----

UPDATE fts
SET fts.DimTicketClassId = 52
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 4 AND PriceCode IN ('ATGZ','ATSR')
AND		seasoncode LIKE 'BS%'



----GROUP COKE PAVILION----

UPDATE fts
SET fts.DimTicketClassId = 53
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 4 AND PriceCode = 'ACK'
AND		seasoncode LIKE 'BS%'



----SEAT DONATION BOX----

UPDATE fts
SET fts.DimTicketClassId = 54
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode = 'BS16' AND DimTicketTypeID = 12 AND PriceCode = 'ABX')
		OR (SeasonCode IN ('BS17', 'BS18') AND DimTicketTypeID = 12 AND PriceCode IN ('EBOX', 'EBND'))



----SEAT DONATION GOLD----

UPDATE fts
SET fts.DimTicketClassId = 55
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode = 'BS16' AND DimTicketTypeID = 12 AND PriceCode IN ('AGF','AGL'))
		OR (SeasonCode IN ('BS17', 'BS18') AND DimTicketTypeID = 12 AND PriceCode IN ('FGLD','FGND'))



----SEAT DONATION GARNET----

UPDATE fts
SET fts.DimTicketClassId = 56
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode = 'BS16' AND DimTicketTypeID = 12 AND PriceCode IN ('AGR','AG2'))
		OR (SeasonCode IN ('BS17', 'BS18') AND DimTicketTypeID = 12 AND PriceCode IN ('GGAR', 'GGND'))



----SEAT DONATION BLACK----

UPDATE fts
SET fts.DimTicketClassId = 57
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode = 'BS16' AND DimTicketTypeID = 12 AND PriceCode IN ('ABL','ABF'))
		OR (SeasonCode IN ('BS17', 'BS18') AND DimTicketTypeID = 12 AND PriceCode IN ('HLBK','HBND'))



----SEAT DONATION COMP----

UPDATE fts
SET fts.DimTicketClassId = 58
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 12 AND PriceCode IN ('ADC','AFC')
AND		seasoncode LIKE 'BS%'



----SEAT DONATION----

UPDATE fts
SET fts.DimTicketClassId = 59
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode = 'BS16' AND DimTicketTypeID = 12 AND PriceCode IN ('A'))
		OR (SeasonCode IN ('BS17', 'BS18') AND DimTicketTypeID = 12 AND PriceCode IN ('A', 'E','F', 'G', 'H'))



----SEAT PREMIUM CLUB----

UPDATE fts
SET fts.DimTicketClassId = 60
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode = 'BS16' AND DimTicketTypeID = 13 AND PriceCode IN ('ACL'))
		OR (SeasonCode IN ('BS17') AND DimTicketTypeID = 13 AND PriceCode IN ('BCLB', 'BCND', 'BCP5', 'BCR4', 'BCR5'))
		OR (SeasonCode IN ('BS18') AND DimTicketTypeID = 13 AND PriceCode IN ('BCLB', 'BCND', 'BCP5', 'BCR4', 'BCR5', 'BDEV', 'BPDV'))



----SEAT PREMIUM PERCH----

UPDATE fts
SET fts.DimTicketClassId = 61
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode = 'BS16' AND DimTicketTypeID = 13 AND PriceCode IN ('APR','APR-1'))
		OR (SeasonCode IN ('BS17', 'BS18') AND DimTicketTypeID = 13 AND PriceCode IN ('CPER','CPND', 'DNDT', 'DPTA'))



----SEAT PREMIUM----

UPDATE fts
SET fts.DimTicketClassId = 62
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode = 'BS16' AND DimTicketTypeID = 13 AND PriceCode IN ('A'))
		OR (SeasonCode IN ('BS17', 'BS18') AND DimTicketTypeID = 13 AND PriceCode IN ('B', 'C', 'D'))



----POST SEASON SINGLE GAME STH----

UPDATE fts
SET fts.DimTicketClassId = 63
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode = 'BS16' AND DimTicketTypeID = 9 AND PriceCode IN ('ABX','ACL','AGA','AND','ANDC','ANDP','AOL','AR','BRS','COF','DSR','AOS','APTA','ASU'))
		OR (SeasonCode IN ('BS17', 'BS18') AND DimTicketTypeID = 9 AND PriceCode IN ('ABX','ACL','AGA','ANDC','ANDP', 'ANP','AOL', 'APS', 'APTA', 'AR', 'ASCO', 'ASU', 'BRS', 'COF', 'DSR'))



----POST SEASON SINGLE GAME PUBLIC----

UPDATE fts
SET fts.DimTicketClassId = 64
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 9 AND PriceCode IN ('ERS','FOF','GSR')
AND		seasoncode LIKE 'BS%'



----POST SEASON SINGLE GAME COMP----

UPDATE fts
SET fts.DimTicketClassId = 65
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 9 AND PriceCode IN ('AC','ACSR')
AND		seasoncode LIKE 'BS%'



----POST SEASON SINGLE GAME YOUTH----

UPDATE fts
SET fts.DimTicketClassId = 83
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 9 AND PriceCode IN ('ARSY', 'COSY', 'DSSY')
AND		seasoncode LIKE 'BS%'



----POST SEASON SINGLE GAME STUDENT----

UPDATE fts
SET fts.DimTicketClassId = 38
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode = 'BS16' AND DimTicketTypeID = 9 AND PriceCode IN ('OSBG'))
		OR (SeasonCode IN ('BS17', 'BS18') AND DimTicketTypeID = 9 AND PriceCode IN ('ZSBG'))



----POST SEASON SINGLE GAME PREMIUM----

UPDATE fts
SET fts.DimTicketClassId = 66
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 9 AND PriceCode IN ('CBSG','PRSG','PTSG')
AND		seasoncode LIKE 'BS%'



----POST SEASON SINGLE GAME----

UPDATE fts
SET fts.DimTicketClassId = 39
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode = 'BS16' AND DimTicketTypeID = 9 AND PriceCode IN ('A','B','C','D','O','Z'))
		OR (SeasonCode = 'BS17' AND DimTicketTypeID = 9 AND PriceCode IN ('A','B','C','D','E', 'F', 'G'))
		OR (SeasonCode = 'BS18' AND DimTicketTypeID = 9 AND PriceCode IN ('A','B','C','D','E', 'F', 'G', 'Z'))



----POST SEASON PLAN STH----

UPDATE fts
SET fts.DimTicketClassId = 68
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode = 'BS16' AND DimTicketTypeID = 8 AND PriceCode IN ('ABX','ACL','AGA','AND','ANDC','ANDP','AOL','AR','BRS','COF','DSR','APS','APTA','ASU'))
		OR (SeasonCode = 'BS18' AND DimTicketTypeID = 8 AND PriceCode IN ('ABX','ACL','AGA','ANDC','ANDP', 'ANP','AOL','AR','APS','APTA','ASU','BRS','COF','DSR'))



----POST SEASON PLAN PUBLIC----

UPDATE fts
SET fts.DimTicketClassId = 69
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	DimTicketTypeID = 8 AND PriceCode IN ('ERS','FOF','GSR')
AND		seasoncode LIKE 'BS%'



----POST SEASON PLAN COMP----

UPDATE fts
SET fts.DimTicketClassId = 70
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId	
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode IN ('BS16', 'BS17') AND DimTicketTypeID = 8 AND PriceCode = 'AC')
		OR (SeasonCode = 'BS18' AND DimTicketTypeID = 8 AND PriceCode IN ('AC', 'ACSR'))



----POST SEASON PLAN----

UPDATE fts
SET fts.DimTicketClassId = 40
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode IN ('BS16', 'BS17') AND DimTicketTypeID = 8 AND PriceCode IN ('A','B','C','D','E','F','G'))
		OR (SeasonCode IN ('BS18') AND DimTicketTypeID = 8 AND PriceCode IN ('A','B','C','D','E','F','G', 'Z'))




----SEAT DONATION FACULTY BOX----

UPDATE fts
SET fts.DimTicketClassId = 84
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode IN ('BS18') AND PriceCode = 'ABXF')




----SEAT DONATION FACULTY GOLD----

UPDATE fts
SET fts.DimTicketClassId = 85
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode IN ('BS18') AND PriceCode = 'JF50')




----SEAT DONATION FACULTY GARNET----

UPDATE fts
SET fts.DimTicketClassId = 86
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode IN ('BS18') AND PriceCode = 'KF25')




----SEAT DONATION FACULTY BLEACHER----

UPDATE fts
SET fts.DimTicketClassId = 87
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode IN ('BS18') AND PriceCode = 'MFOF')




----SEAT DONATION FACULTY----

UPDATE fts
SET fts.DimTicketClassId = 88
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode IN ('BS18') AND PriceCode IN ('A', 'J', 'K', 'M'))




----SEAT DONATION SENIOR BOX----

UPDATE fts
SET fts.DimTicketClassId = 89
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode IN ('BS18') AND PriceCode = 'SBOX')




----SEAT DONATION SENIOR GOLD----

UPDATE fts
SET fts.DimTicketClassId = 90
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode IN ('BS18') AND PriceCode = 'SGLD')




----SEAT DONATION SENIOR GARNET----

UPDATE fts
SET fts.DimTicketClassId = 91
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode IN ('BS18') AND PriceCode = 'SGAR')




----SEAT DONATION SENIOR BLACK----

UPDATE fts
SET fts.DimTicketClassId = 92
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE	(SeasonCode IN ('BS18') AND PriceCode = 'SBLK')






/*****************************************************************************************************************
															SEAT TYPE
******************************************************************************************************************/

-----------------------Football 2016-----------------------

----GARNET----

UPDATE fts
SET fts.DimSeatTypeId = 1
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	(SeasonCode IN ('FB15', 'FB16') AND ParentPriceCode IN ('F','M','T'))
		OR (SeasonCode IN ('FB17', 'FB18') AND ParentPriceCode = 'E')



----RED----

UPDATE fts
SET fts.DimSeatTypeId = 2
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	(SeasonCode IN ('FB15', 'FB16') AND ParentPriceCode IN ('G','N','U'))
		OR (SeasonCode IN ('FB17', 'FB18') AND ParentPriceCode = 'F')


	   
----GREY----

UPDATE fts
SET fts.DimSeatTypeId = 3
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	(SeasonCode IN ('FB15', 'FB16') AND ParentPriceCode IN ('H','O','V'))
		OR (SeasonCode IN ('FB17', 'FB18') AND ParentPriceCode = 'G')


	   
----BLUE----

UPDATE fts
SET fts.DimSeatTypeId = 4
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	(SeasonCode IN ('FB15', 'FB16') AND ParentPriceCode IN ('I','P','W'))
		OR (SeasonCode IN ('FB17', 'FB18') AND ParentPriceCode = 'H')



----GREEN----

UPDATE fts
SET fts.DimSeatTypeId = 5
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	(SeasonCode IN ('FB15', 'FB16') AND ParentPriceCode IN ('J','Q','X'))
		OR (SeasonCode IN ('FB17', 'FB18') AND ParentPriceCode = 'I')



----YELLOW----
UPDATE fts
SET fts.DimSeatTypeId = 6
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	(SeasonCode IN ('FB15', 'FB16') AND ParentPriceCode IN ('K','R','Y'))
		OR (SeasonCode IN ('FB17', 'FB18') AND ParentPriceCode = 'J')



----BLACK----
UPDATE fts
SET fts.DimSeatTypeId = 7
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	(SeasonCode IN ('FB15', 'FB16') AND ParentPriceCode IN ('L','S','Z'))
		OR (SeasonCode IN ('FB17', 'FB18') AND ParentPriceCode = 'K')



----CHAMPIONS CLUB----
UPDATE fts
SET fts.DimSeatTypeId = 8
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	(SeasonCode IN ('FB15', 'FB16') AND ParentPriceCode = 'B')
		OR (SeasonCode IN ('FB17', 'FB18') AND ParentPriceCode = 'A')



----200 EXEC----
UPDATE fts
SET fts.DimSeatTypeId = 9
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	(SeasonCode IN ('FB15', 'FB16') AND ParentPriceCode = 'C')
		OR (SeasonCode IN ('FB17', 'FB18') AND ParentPriceCode = 'B')



----600 EXEC----

UPDATE fts
SET fts.DimSeatTypeId = 10
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	(SeasonCode IN ('FB15', 'FB16') AND ParentPriceCode = 'D')
		OR (SeasonCode IN ('FB17', 'FB18') AND ParentPriceCode = 'C')



----STUDENT----

UPDATE fts
SET fts.DimSeatTypeId = 11
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
		JOIN dbo.dimevent de ON fts.DimEventID = de.DimEventID
WHERE	SeasonCode LIKE 'FB%' AND ((ParentPriceCode = 'A' AND ItemCode LIKE 'STU%') OR (PriceCode IN ('BSTU', 'ASA') AND SeasonCode = 'FB17'))



----THE ZONE----

UPDATE fts
SET fts.DimSeatTypeId = 11
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	(SeasonCode IN ('FB15', 'FB16') AND ParentPriceCode = 'E')
		OR (SeasonCode IN ('FB17', 'FB18') AND ParentPriceCode = 'D')



----ACCESSIBLE----

UPDATE fts
SET fts.DimSeatTypeId = 13
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	RowName = 'WC'
AND		SeasonCode LIKE 'FB%'



----PREMIUM----

UPDATE fts
SET fts.DimSeatTypeId = 14
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	(SeasonCode IN ('FB15', 'FB16') AND PriceCode IN ('AS','AS2'))
		OR (SeasonCode IN ('FB17', 'FB18') AND PriceCode = 'SSTE')



-----------------------Men's Basketball 2016-2017-----------------------

----FOUNDER'S CLUB----

UPDATE fts
SET fts.DimSeatTypeId = 15
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	(SeasonCode = 'BB17' AND ParentPriceCode = 'G')
		OR (SeasonCode = 'BB18' AND ParentPriceCode IN ('A', 'B'))



----LOWER LEVEL----

UPDATE fts
SET fts.DimSeatTypeId = 16
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	(SeasonCode = 'BB17' AND ParentPriceCode = 'H')
		OR (SeasonCode = 'BB18' AND ParentPriceCode = 'C')


	   
----UPPER LEVEL----

UPDATE fts
SET fts.DimSeatTypeId = 17
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	(SeasonCode = 'BB17' AND ParentPriceCode IN ('J','K'))
		OR (SeasonCode = 'BB18' AND ParentPriceCode IN ('D', 'F', 'G'))


	   
----COKE ZERO----

UPDATE fts
SET fts.DimSeatTypeId = 8
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	(SeasonCode = 'BB16' AND ParentPriceCode IN ('I', 'T'))
		OR (SeasonCode = 'BB17' AND ParentPriceCode IN ('I'))
		OR (SeasonCode = 'BB18' AND ParentPriceCode = 'E')



----STUDENT SEATING----

UPDATE fts
SET fts.DimSeatTypeId = 11
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	(SeasonCode = 'BB16' AND ParentPriceCode IN ('Z', 'B'))
		OR (SeasonCode IN ('BB17', 'BB18') AND ParentPriceCode IN ('Z'))



----FACULTY UPPER----
UPDATE fts
SET fts.DimSeatTypeId = 19
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	(SeasonCode = 'BB17' AND ParentPriceCode = 'N')
		OR (SeasonCode = 'BB18' AND ParentPriceCode = 'D')



----FACULTY LOWER----
UPDATE fts
SET fts.DimSeatTypeId = 20
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	(SeasonCode = 'BB17' AND ParentPriceCode = 'M')
		OR (SeasonCode = 'BB18' AND ParentPriceCode = 'C')



----SUITE SEATING----
UPDATE fts
SET fts.DimSeatTypeId = 21
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	(SeasonCode IN ('BB17', 'BB18') AND ParentPriceCode = 'S')



----ACCESSIBLE----
UPDATE fts
SET fts.DimSeatTypeId = 13
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	(SeasonCode IN ('BB17', 'BB18') AND RowName = 'WC')



----YOUNG ALUMNI----
UPDATE fts
SET fts.DimSeatTypeId = 31
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	(SeasonCode = 'BB18' AND ParentPriceCode = 'H')



-----------------------Women's Basketball 2016-2017-----------------------

----LOWER RESERVED----

UPDATE fts
SET fts.DimSeatTypeId = 22
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	(SeasonCode = 'WB16' AND ParentPriceCode IN ('A', 'D'))
		OR (SeasonCode = 'WB17' AND ParentPriceCode = 'C')
		OR (SeasonCode = 'WB18' AND ParentPriceCode = 'B')




----CORNER RESERVED----

UPDATE fts
SET fts.DimSeatTypeId = 23
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	(SeasonCode = 'WB17' AND ParentPriceCode = 'D')
		OR (SeasonCode = 'WB18' AND ParentPriceCode = 'C')


	   
----GENERAL ADMISSION----

UPDATE fts
SET fts.DimSeatTypeId = 24
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	ParentPriceCode IN ('E')
AND		SeasonCode IN ('WB16', 'WB17', 'WB18')


	   
----STUDENT----

UPDATE fts
SET fts.DimSeatTypeId = 11
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	(SeasonCode = 'WB16' AND ParentPriceCode = 'B')
OR		(SeasonCode IN ('WB17', 'WB18') AND ParentPriceCode = 'Z')



----SUITE TICKETS----

UPDATE fts
SET fts.DimSeatTypeId = 21
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	(SeasonCode = 'WB17' AND ParentPriceCode = 'F')
		OR (SeasonCode = 'WB18' AND ParentPriceCode = 'S')



----ACCESSIBLE----
UPDATE fts
SET fts.DimSeatTypeId = 13
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	RowName = 'WC'
AND		SeasonCode LIKE 'WB%'



----BASELINE RESERVED----
UPDATE fts
SET fts.DimSeatTypeId = 25
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	(SeasonCode = 'WB17' AND ParentPriceCode = 'B')
		OR (SeasonCode = 'WB18' AND ParentPriceCode = 'D')



-----------------------Baseball-----------------------

----CLUB LEVEL----

UPDATE fts
SET fts.DimSeatTypeId = 26
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	PriceCode = 'ACL'
AND		SeasonCode LIKE 'BS%'



----PERCH----

UPDATE fts
SET fts.DimSeatTypeId = 27
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	PriceCode IN ('APS','APTA')
AND		SeasonCode LIKE 'BS%'


	   
----BOX----

UPDATE fts
SET fts.DimSeatTypeId = 28
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	PriceCode = 'ABX'
AND		SeasonCode LIKE 'BS%'


	   
----GOLD----

UPDATE fts
SET fts.DimSeatTypeId = 29
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	PriceCode IN ('AGF','AGL')
AND		SeasonCode LIKE 'BS%'



----GARNET----

UPDATE fts
SET fts.DimSeatTypeId = 1
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	PriceCode IN ('AGR','AG2')
AND		SeasonCode LIKE 'BS%'



----BLACK----
UPDATE fts
SET fts.DimSeatTypeId = 7
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	PriceCode IN ('ABL','ABF')
AND		SeasonCode LIKE 'BS%'



----SUITE----
UPDATE fts
SET fts.DimSeatTypeId = 21
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	PriceCode = 'ASU'
AND		SeasonCode LIKE 'BS%'



----OUTFIELD----
UPDATE fts
SET fts.DimSeatTypeId = 30
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	PriceCode IN ('AOL','AF02')
AND		SeasonCode LIKE 'BS%'



----GENERAL ADMISSION----
UPDATE fts
SET fts.DimSeatTypeId = 24
FROM    #stgFactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
		JOIN dbo.DimSeat s ON s.SSID_section_id = fts.SSID_section_id
WHERE	PriceCode = 'AGA'
AND		SeasonCode LIKE 'BS%'





/*****************************************************************************************************************
												SEAT CONFIG_LOCATION
******************************************************************************************************************/

UPDATE dbo.dimseat
SET Config_Location = 
	(CASE WHEN DimArenaID = 1 AND SectionName IN ('203','204','205','206','207','203WC','204WC','205WC','206WC','207WC') THEN '200 Exec Club'
	WHEN DimArenaID = 1 AND SectionName IN ('601','602','603','604','605','606','602WC','604WC') THEN '600 Exec Club'
	WHEN DimArenaID = 1 AND SectionName IN ('1WC','9WC','11WC','12WC','13WC','14WC','401WC','419WC','902WC','903WC','904WC','905WC','906WX','907WC') THEN 'Accessible'
	WHEN DimArenaID = 1 AND SectionName IN ('201','202','208','209') THEN 'Champions Club'
	WHEN DimArenaID = 1 AND SectionName IN ('401','402','403','404','405','406','407','408','409','410','411','412','413','414','415','416','417','418','419') THEN 'East Club'
	WHEN DimArenaID = 1 AND SectionName IN ('17','18','19','20','21','22') THEN 'East Lower'
	WHEN DimArenaID = 1 AND SectionName IN ('501','502','503','504','505','506','507','508') THEN 'East Upper'
	WHEN DimArenaID = 1 AND SectionName IN ('101','102','103','104','105','106','107','108','109') THEN 'West Club'
	WHEN DimArenaID = 1 AND SectionName IN ('1','2','3','4','5','6','7','8','9') THEN 'West Lower'
	WHEN DimArenaID = 1 AND SectionName IN ('301','302','303','304','305','306','307','308','309') THEN 'West Upper'
	WHEN DimArenaID = 1 AND SectionName IN ('10','11','12','13','14','15') THEN 'South End Zone'
	WHEN DimArenaID = 1 AND SectionName IN ('901','902','903','904','905','906','907','908') THEN 'South Upper'
	WHEN DimArenaID = 1 AND SectionName IN ('23','24') THEN 'Student Seating'
	WHEN DimArenaID = 1 AND SectionName LIKE '8%' THEN 'The Zone'
	WHEN DimArenaID = 1 AND SectionName IN ('S1','S2','S3','S4','S5','S6','S7','S8','S9','S10','S11','S12','S13','S14','S15','S16','S17','S18') THEN 'Suites'
	WHEN DimArenaID = 8 AND SectionName IN ('101','109','118') THEN 'Lower Level Baseline'
	WHEN DimArenaID = 8 AND SectionName LIKE '%FL' THEN 'Courtside'
	WHEN DimArenaID = 8 AND SectionName IN ('102','103','107','108','116','117') THEN 'Lower Level Corner'
	WHEN DimArenaID = 8 AND SectionName IN ('104','105','106','113','114','115') THEN 'Lower Level Side Court'
	WHEN DimArenaID = 8 AND Sectionname IN ('110','111','112') THEN 'Student'
	WHEN DimArenaID = 8 AND SectionName IN ('201','202','214','215','216','228') THEN 'Upper Level Baseline'
	WHEN DimArenaID = 8 AND SectionName IN ('203','204','205','206','210','211','212','213','217','218','219','220','224','225','226','227') THEN 'Upper Level Corner'
	WHEN DimArenaID = 8 AND SectionName IN ('207','208','209','221','222','223') THEN 'Suite Seating'
	WHEN DimArenaID = 8 AND SectionName IN ('STEA','STEB','STEC','STED') THEN 'Super Suite Seating'
	WHEN dimarenaid = 9 AND sectionname IN ('104','105','106','113','114','115') THEN 'Lower Reserved'
	WHEN dimarenaid = 9 AND sectionname IN ('102','103','107','108','116','117') THEN 'Corner Reserved'
	WHEN dimarenaid = 9 AND sectionname LIKE 'GA%' THEN 'General Admission'
	WHEN dimarenaid = 9 AND sectionname IN ('110','111','112') THEN 'Student'
	WHEN dimarenaid = 9 AND sectionname LIKE 'STE%' THEN 'Suite'
	WHEN dimarenaid = 9 AND sectionname IN ('101','118','109') THEN 'Baseline Reserved'
	WHEN dimarenaid = 10 AND sectionname LIKE '[2-25]' THEN 'Reserved Chair Backs'
	WHEN dimarenaid = 10 AND sectionname IN ('26','27','28') THEN 'Reserved Outfield Wall'
	WHEN dimarenaid = 10 AND sectionname IN ('OF1') THEN 'Outfield Bleacher'
	WHEN dimarenaid = 10 AND sectionname LIKE 'BOX%' THEN 'Reserved Box Seating'
	WHEN dimarenaid = 10 AND sectionname IN ('1') THEN 'Student Reserved'
	WHEN dimarenaid = 10 AND sectionname LIKE 'Suite%' THEN 'Suites Seating'
	WHEN dimarenaid = 10 AND sectionname LIKE 'Club%' THEN 'Club Seating'
	WHEN dimarenaid = 10 AND sectionname LIKE 'UP%' THEN 'Perch Seating'
	WHEN dimarenaid = 10 AND sectionname LIKE 'GA%' THEN 'Standing Room Only'
	WHEN dimarenaid = 10 AND sectionname LIKE 'CK%' THEN 'Coke Pavilion Tables'
	WHEN dimarenaid = 10 AND sectionname LIKE 'PTAB%' THEN 'Perch Tables'
	END)



	

/*****************************************************************************************************************
													FACT TAGS
******************************************************************************************************************/


UPDATE f
SET f.IsComp = 1
FROM #stgFactTicketSales f
	JOIN dbo.DimPriceCode dpc
	ON dpc.DimPriceCodeId = f.DimPriceCodeId
WHERE f.compname <> 'Not Comp'
	  OR PriceCodeDesc = 'Comp'
	  OR f.TotalRevenue = 0
	  OR f.dimplantypeid = 5


UPDATE f
SET f.IsComp = 0
FROM #stgFactTicketSales f
	JOIN dbo.DimPriceCode dpc
	ON dpc.DimPriceCodeId = f.DimPriceCodeId
WHERE NOT (f.compname <> 'Not Comp'
		   OR PriceCodeDesc = 'Comp'
		   OR f.TotalRevenue = 0)
	OR f.dimplantypeid <> 5

UPDATE f
SET f.IsPlan = 1
, f.IsPartial = 0
, f.IsSingleEvent = 0
, f.IsGroup = 0
FROM #stgFactTicketSales f
WHERE DimTicketTypeId IN (1,5,11,12,13) 



UPDATE f
SET f.IsPlan = 1
, f.IsPartial = 1
, f.IsSingleEvent = 0
, f.IsGroup = 0
FROM #stgFactTicketSales f
WHERE DimTicketTypeId IN (2,6,7,8,10) 


UPDATE f
SET f.IsPlan = 0
, f.IsPartial = 0
, f.IsSingleEvent = 1
, f.IsGroup = 1
FROM #stgFactTicketSales f
WHERE DimTicketTypeId IN (4) 


UPDATE f
SET f.IsPlan = 0
, f.IsPartial = 0
, f.IsSingleEvent = 1
, f.IsGroup = 0
FROM #stgFactTicketSales f
WHERE DimTicketTypeId IN (3,9) 

/*
UPDATE f
SET f.IsPremium = 1
FROM #stgFactTicketSales f
INNER JOIN dbo.DimSeatType dst ON f.DimSeatTypeId = dst.DimSeatTypeId
WHERE dst.SeatTypeCode <> 'GA'


UPDATE f
SET f.IsPremium = 0
FROM #stgFactTicketSales f
INNER JOIN dbo.DimSeatType dst ON f.DimSeatTypeId = dst.DimSeatTypeId
WHERE dst.SeatTypeCode = 'GA'
*/


UPDATE f
SET f.IsRenewal = 1
FROM #stgFactTicketSales f
INNER JOIN dbo.DimPlanType dpt ON f.DimPlanTypeId = dpt.DimPlanTypeId
WHERE dpt.DimPlanTypeID = 2


UPDATE f
SET f.IsRenewal = 0
FROM #stgFactTicketSales f
INNER JOIN dbo.DimPlanType dpt ON f.DimPlanTypeId = dpt.DimPlanTypeId
WHERE dpt.DimPlanTypeID <> 2
	

END

GO
