SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_KeyAccounts_CRMAccounts]
AS 

--WITH SSBID AS (
--	SELECT DISTINCT ssbid.SSB_CRMSYSTEM_ACCT_ID
--	FROM mdm.vw_TM_STH vw
--	JOIN dbo.dimcustomerssbid ssbid WITH (NOLOCK) ON vw.dimcustomerid = ssbid.DimCustomerid
--	WHERE ssbid.SSB_CRMSYSTEM_ACCT_ID IS NOT NULL AND vw.STH = 1
--	)


SELECT dc.DimCustomerID, dc.SSB_CRMSYSTEM_ACCT_ID SSBID, dc.SSID
FROM (
		SELECT DISTINCT ssbid.SSB_CRMSYSTEM_ACCT_ID
		FROM --mdm.vw_TM_STH vw  
			(
				SELECT DimCustomerid, STH FROM mdm.vw_TM_STH vw WHERE STH = 1
			) vw
		INNER JOIN dbo.DimCustomerSSBID ssbid WITH (NOLOCK)
			ON  vw.DimCustomerid = ssbid.DimCustomerid
		WHERE ssbid.SSB_CRMSYSTEM_ACCT_ID IS NOT NULL 
			AND vw.STH = 1
	) vw
INNER JOIN dbo.vwDimCustomer_ModAcctId dc WITH (NOLOCK) 
	ON  vw.SSB_CRMSYSTEM_ACCT_ID = dc.SSB_CRMSYSTEM_ACCT_ID
WHERE dc.SourceSystem = 'SouthCarolina PC_SFDC Contact'


GO
