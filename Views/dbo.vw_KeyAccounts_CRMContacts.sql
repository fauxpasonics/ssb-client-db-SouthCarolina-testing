SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [dbo].[vw_KeyAccounts_CRMContacts]
AS 

WITH SSBID AS (
	SELECT DISTINCT ssbid.SSB_CRMSYSTEM_CONTACT_ID
	FROM mdm.vw_TM_STH vw WITH (NOLOCK)
	JOIN dbo.dimcustomerssbid ssbid WITH (NOLOCK) ON vw.dimcustomerid = ssbid.DimCustomerid
	WHERE vw.STH = 1
	)


SELECT dc.DimCustomerID, dc.SSB_CRMSYSTEM_CONTACT_ID SSBID, dc.SSID
FROM SSBID vw
JOIN dbo.vwDimCustomer_ModAcctId dc WITH (NOLOCK) ON vw.SSB_CRMSYSTEM_CONTACT_ID = dc.SSB_CRMSYSTEM_CONTACT_ID
WHERE dc.SourceSystem = 'SouthCarolina PC_SFDC Contact'




GO
