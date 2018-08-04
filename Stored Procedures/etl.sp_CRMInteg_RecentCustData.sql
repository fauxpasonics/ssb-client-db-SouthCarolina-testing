SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [etl].[sp_CRMInteg_RecentCustData]
AS

TRUNCATE TABLE etl.CRMProcess_RecentCustData

DECLARE @Client VARCHAR(50)
SET @Client = 'South Carolina'

SELECT x.dimcustomerid, MAX(x.maxtransdate) maxtransdate, x.team
INTO #tmpTicketSales
	FROM (
		SELECT ft.DimCustomerID, MAX(dd.calDate) MaxTransDate , @Client Team
		--Select * 
		FROM dbo.FactTicketSales ft WITH(NOLOCK)
		INNER JOIN dbo.DimDate dd (NOLOCK)
			on ft.dimdateID = dd.DimdateID	
		WHERE dd.calDate >= DATEADD(YEAR, -3, GETDATE())
		GROUP BY ft.[DimCustomerId]

		UNION ALL

		SELECT dc.DimCustomerId, MAX(donor.pledge_datetime) Maxdonationdate, @Client Team
		FROM dbo.dimcustomer dc (NOLOCK)
		JOIN ods.TM_Donation donor (NOLOCK)
			ON dc.AccountId = donor.acct_id
		WHERE donor.pledge_datetime >= DATEADD(YEAR, -3, GETDATE())
		GROUP BY dc.[DimCustomerId]

		UNION ALL

		SELECT dc.dimcustomerid, dc.CreatedDate maxtransdate, @client Team
		FROM dbo.DimCustomer dc (NOLOCK)
		WHERE dc.CreatedDate > '2016-12-31 00:00:00.000' --date of request
		AND dc.SourceSystem = 'tm'

		UNION ALL

		SELECT dc.DimCustomerId, max(upd_Datetime) maxtransdate, @Client Team
		 FROM [ods].[TM_Note] tmn WITH (NOLOCK)
		JOIN [dbo].dimcustomer dc WITH (NOLOCK) 
			on dc.SourceSystem = 'TM' and tmn.acct_id = dc.accountid and dc.CustomerType = 'Primary'
		where upd_Datetime > '2016-12-31 00:00:00.000'
		group BY DimCustomerId

		UNION ALL

		SELECT dc.DimCustomerID, MAX(CreatedDate) MaxTransDate , @Client Team
		--Select * 
		FROM  dbo.DimCustomer dc (NOLOCK)
		WHERE SourceSystem like 'USC_LoadCRM_%'
		AND (dc.CreatedDate >= GETDATE() -10 OR dc.UpdatedDate >= GETDATE() -10)
		GROUP BY dc.[DimCustomerId]
		

		) x
		GROUP BY x.dimcustomerid, x.team


INSERT INTO etl.CRMProcess_RecentCustData (SSID, MaxTransDate, Team)
SELECT SSID, [MaxTransDate], Team 
FROM [#tmpTicketSales] a 
INNER JOIN dbo.[vwDimCustomer_ModAcctId] b ON [b].[DimCustomerId] = [a].[DimCustomerId]



--INSERT INTO etl.CRMProcess_RecentCustData ( SSID, MaxTransDate, Team)
--SELECT DISTINCT cr.SSID, GETDATE() MaxTransDate, 'South Carolina' Team
--FROM rpt.vw_CRM_HistoricalNotes note
--JOIN mdm.compositerecord cr ON note.SSB_CRMSYSTEM_CONTACT_ID__c = cr.SSB_CRMSYSTEM_CONTACT_ID
--WHERE cr.SSID NOT IN (SELECT DISTINCT SSID FROM etl.CRMProcess_RecentCustData)


GO
