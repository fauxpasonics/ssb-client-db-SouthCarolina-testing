SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--select count(*) FROM [dbo].[vwCRMLoad_TicketTransactions]
--select distinct SeasonName__c from [dbo].[vwCRMLoad_TicketTransactions]



CREATE VIEW [dbo].[vwCRMLoad_TicketTransactions] AS 

SELECT 'South Carolina'									AS Team__c --updateme
      , fts.ArchticsAccountId								AS TicketingAccountID__c
      , fts.SeasonName										AS SeasonName__c
 , fts.FactTicketSalesId									AS FactTicketSalesID__c
      , fts.OrderNum										AS OrderNumber__c
      , fts.OrderLineItem									AS OrderLine__c
      , fts.TransDateTime										AS OrderDate__c
      , fts.ItemCode										AS Item__c
      , fts.ItemName										AS ItemName__c
 , fts.EventDate											AS EventDate__c
      , fts.PriceCode										AS PriceCode__c
      , fts.IsComp											AS IsComp__c
      , fts.PromoCode										AS PromoCode__c
      , fts.QtySeat											AS QtySeat__c
      , fts.SectionName										AS SectionName__c
      , fts.RowName											AS RowName__c
      , fts.Seat											AS Seat__c
      , CAST(fts.BlockPurchasePrice	AS decimal (12,2))		AS SeatPrice__c
      , CAST(fts.TotalRevenue AS decimal (12,2))			AS Total__c
      , CAST(fts.OwedAmount	AS decimal (12,2))				AS OwedAmount__c
      , CAST(fts.PaidAmount	AS decimal (12,2))				AS PaidAmount__c
      , NULL											    AS SalesRep__c -- this can be added once new model is available
FROM   dbo.vw_FactTicketSalesBase fts WITH (NOLOCK)
INNER JOIN [dbo].[vwDimCustomer_ModAcctId] dc WITH (NOLOCK) on dc.SourceSystem = 'TM' AND dc.AccountId = fts.ArchticsAccountId AND dc.CustomerType = 'Primary'
WHERE fts.SeasonName NOT LIKE '%Student%'
GO
