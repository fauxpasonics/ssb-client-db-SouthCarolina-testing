SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [rpt].[vw_CRM_LoadOpportunityTemplate]
AS (select DISTINCT
'01241000000bDIR' AS RecordTypeId
, u.Id AS OwnerId
, 'x' AS Name
, c.accountid AS AccountId
, c.Id as Contact_Name__c
, 'Football' AS Sport
, '2017 - 2018' AS Season
, 'Full Season' AS Ticket_Type__c
, 'FB16 Lapsed' AS Short_Description__c
, Stage
, CAST([Close Date] as DATE) AS CloseDate
, [Campaign ID] AS CampaignId
, 'Assigned Opportunity' AS LeadSource
, 'New - Ticketing' AS Type
, dc.SSB_CRMSYSTEM_CONTACT_ID
 from [dbo].[USC_FB16Lapsed_20170130] a
JOIN [dbo].[vwDimCustomer_ModAcctId] dc ON dc.SourceSystem = 'TM' and a.AccountID = dc.AccountID and CustomerType = 'Primary'
JOIN SSBCIDW04.SouthCarolina_Reporting.ProdCopy.vw_Contact c on dc.SSB_CRMSYSTEM_CONTACT_ID = c.[SSB_CRMSYSTEM_CONTACT_ID__c]
JOIN  SSBCIDW04.SouthCarolina_Reporting.[prodcopy].[User] u on a.Rep = u.Name

)
GO
