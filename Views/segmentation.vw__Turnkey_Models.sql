SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO










CREATE VIEW  [segmentation].[vw__Turnkey_Models]

AS


WITH Basketball (SSB_CRMSYSTEM_CONTACT_ID, BasketballPriority, GroupPriority)
AS (
	SELECT DISTINCT c.SSB_CRMSYSTEM_CONTACT_ID
						  ,c.[Priority]
						  ,c.GroupPriority
	FROM dbo.vwDimCustomer_ModAcctId a
	INNER JOIN ( SELECT
			b.SSB_CRMSYSTEM_CONTACT_ID
						  ,models.*
						  --,t.[TurnkeyStandardBundleDate]
						  ,ROW_NUMBER() OVER (PARTITION BY b.SSB_CRMSYSTEM_CONTACT_ID ORDER BY t.TurnkeyStandardBundleDate DESC) RN
			FROM ods.Turnkey_Acxiom t 
			INNER JOIN [ods].[Turnkey_Models_old20171118] models ON t.AbilitecID = models.AbilitecID
			INNER JOIN dbo.vwDimCustomer_ModAcctId b ON b.SSID = t.ProspectID AND b.SourceSystem = 'SouthCarolina_Turnkey' 
			WHERE models.Sport = 'Basketball'
		) c	ON a.SSB_CRMSYSTEM_CONTACT_ID = c.SSB_CRMSYSTEM_CONTACT_ID AND c.RN = 1 AND SourceSystem = 'SouthCarolina_Turnkey'
)

, Football (SSB_CRMSYSTEM_CONTACT_ID, FootballPriority, FootballGroupPriority)
AS (
	SELECT DISTINCT c.SSB_CRMSYSTEM_CONTACT_ID
						  ,c.[Priority]
						  ,c.GroupPriority
	FROM dbo.vwDimCustomer_ModAcctId a
	INNER JOIN ( SELECT
			b.SSB_CRMSYSTEM_CONTACT_ID
						  ,models.*
						  --,t.[TurnkeyStandardBundleDate]
						  ,ROW_NUMBER() OVER (PARTITION BY b.SSB_CRMSYSTEM_CONTACT_ID ORDER BY t.TurnkeyStandardBundleDate DESC) RN
			FROM ods.Turnkey_Acxiom t 
			INNER JOIN [ods].[Turnkey_Models_old20171118] models ON t.AbilitecID = models.AbilitecID
			INNER JOIN dbo.vwDimCustomer_ModAcctId b ON b.SSID = t.ProspectID AND b.SourceSystem = 'SouthCarolina_Turnkey' 
			WHERE models.Sport = 'Football'
		) c	ON a.SSB_CRMSYSTEM_CONTACT_ID = c.SSB_CRMSYSTEM_CONTACT_ID AND c.RN = 1 AND SourceSystem = 'SouthCarolina_Turnkey'
)

SELECT COALESCE(b.SSB_CRMSYSTEM_CONTACT_ID, f.SSB_CRMSYSTEM_CONTACT_ID) SSB_CRMSYSTEM_CONTACT_ID, b.BasketballPriority, b.GroupPriority, f.FootballPriority, f.FootballGroupPriority
FROM basketball b
FULL OUTER JOIN football f ON b.ssb_crmsystem_contact_id = f.ssb_crmsystem_contact_id








GO
