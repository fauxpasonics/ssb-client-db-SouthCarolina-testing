SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[SkiData_ExportFile_StageData]

AS 
BEGIN


TRUNCATE TABLE etl.SkiData_ExportFile_Accounts
TRUNCATE TABLE etl.SkiData_ExportFile_Roles
TRUNCATE TABLE etl.SkiData_ExportFile_ProfileProperties
TRUNCATE TABLE etl.SkiData_ExportFile_Points


SELECT 
	f.SSID_acct_id TicketAccountID, f.DimCustomerId, dc.FirstName, dc.LastName, dc.EmailPrimary Email, dc.CompanyName
    , CASE 
		WHEN isnull(dc.FirstName,'') <> '' and isnull(dc.lastname,'') <> '' THEN CONCAT(replace(dc.FirstName,'/',''), ' ', replace(dc.LastName,'/','')) 
          WHEN isnull(dc.FirstName,'') = '' THEN replace(dc.lastname,'/','') 
		  WHEN isnull(dc.lastname,'') = '' THEN replace(dc.firstname,'/','')
     END as DisplayName	 
	, MIN(dpcm.PC1) PriceLevel
	, CAST(min(odsCust.Since_date) AS date) STHTenure
	, CAST(NULL AS INT) SkiDataUserId
INTO #STH_Accounts
FROM rpt.vw_FactTicketSales f
INNER JOIN rpt.vw_DimPlan dpl ON f.DimPlanId = dpl.DimPlanId	
INNER JOIN rpt.vw_DimPriceCodeMaster dpcm ON f.DimPriceCodeMasterId = dpcm.DimPriceCodeMasterId
INNER JOIN rpt.vw_DimCustomer dc ON f.DimCustomerId = dc.DimCustomerId
INNER JOIN ods.TM_Cust (NOLOCK) odsCust ON f.SSID_acct_id = odsCust.acct_id AND odsCust.Primary_code = 'Primary'
WHERE f.DimSeasonId IN (61) AND (dpl.PlanCode LIKE '16FS%') AND f.IsComp = 0
AND dc.CustomerType = 'Primary' AND FirstName <> '' AND LastName <> '' AND EmailPrimary <> ''
GROUP BY f.SSID_acct_id, f.DimCustomerId, dc.FirstName, dc.LastName, dc.EmailPrimary, dc.CompanyName
, CASE 
	WHEN isnull(dc.FirstName,'') <> '' and isnull(dc.lastname,'') <> '' THEN CONCAT(replace(dc.FirstName,'/',''), ' ', replace(dc.LastName,'/','')) 
    WHEN isnull(dc.FirstName,'') = '' THEN replace(dc.lastname,'/','') 
	WHEN isnull(dc.lastname,'') = '' THEN replace(dc.firstname,'/','')
END


CREATE NONCLUSTERED INDEX IDX_TicketAccountID ON #STH_Accounts (TicketAccountID)
CREATE NONCLUSTERED INDEX IDX_Email ON #STH_Accounts (Email)


UPDATE sth
SET sth.SkiDataUserId = sdu.UserID
FROM #STH_Accounts sth
INNER JOIN ods.SkiData_Users sdu ON sth.TicketAccountID = TRY_CAST(sdu.TicketAccountID AS INT)

UPDATE sth
SET sth.SkiDataUserId = sdu.UserID
FROM #STH_Accounts sth
INNER JOIN ods.SkiData_Users sdu ON sth.Email = sdu.Username
WHERE sth.SkiDataUserId IS NULL

UPDATE sth
SET sth.SkiDataUserId = sdu.UserID
FROM #STH_Accounts sth
INNER JOIN ods.SkiData_Users sdu ON sth.Email = sdu.Email
WHERE sth.SkiDataUserId IS NULL


INSERT INTO etl.SkiData_ExportFile_Accounts
( LRSUserID, TeamUniqueID, TicketAccountID, TicketUserID, FirstName, LastName, Email, UserName, DisplayName, Password, LifetimePointTotal, SpendablePointTotal )

SELECT 
'' LRSUserID
, '' TeamUniqueID 
, sth.TicketAccountID
, null TicketUserID -- Not required
--, sth.FirstName
, CASE
	WHEN isnull(sth.FirstName,'') <> '' THEN replace(sth.firstname,'/','') 
	WHEN isnull(sth.FirstName,'') = '' and isnull(sth.lastname,'') = '' THEN replace(sth.companyname,'/','') 
	ELSE '' 
END as FirstName
--, sth.LastName
, case 
	WHEN isnull(sth.lastname,'') <> '' THEN replace(sth.lastname,'/','') 
	WHEN isnull(sth.FirstName,'') = '' and isnull(sth.lastname,'') = '' THEN replace(sth.companyname,'/','') 
	ELSE '' 
END LastName
, sth.Email
, sth.Email UserName	
, CASE WHEN ISNULL(sth.DisplayName,'') <> '' THEN replace(sth.DisplayName,'/','') ELSE replace(sth.companyname,'/','') END DisplayName
, '' [Password] --not required
, '' LifetimePointTotal --not required
, '' SpendablePointTotal --not required
FROM #STH_Accounts sth
WHERE SkiDataUserId IS NULL


INSERT INTO etl.SkiData_ExportFile_Roles (LRSUserID, TeamUniqueID, TicketAccountID, TicketUserID, RoleID, RoleName, ExpirationDate, [Action])
SELECT 
	sth.SkiDataUserId
	, '' TeamUniqueID 
	, CASE WHEN sth.SkiDataUserId IS NULL then sth.TicketAccountID ELSE null END TicketAccountID
	, null TicketUserID -- Not required
	, 702 RoleID
	, 'Season Ticket Holders' RoleName
	, NULL ExpirationDate
	, 'Add' [Action]
FROM #STH_Accounts sth
LEFT OUTER JOIN ods.SkiData_User_Roles sdur ON sth.SkiDataUserId = sdur.UserID AND sdur.RoleID = 702
WHERE sdur.ETL_ID IS NULL


INSERT INTO etl.SkiData_ExportFile_Roles (LRSUserID, TeamUniqueID, TicketAccountID, TicketUserID, RoleID, RoleName, ExpirationDate, [Action])
SELECT 
	sth.SkiDataUserId
	, '' TeamUniqueID 
	, CASE WHEN sth.SkiDataUserId IS NULL then sth.TicketAccountID ELSE null END TicketAccountID
	, null TicketUserID -- Not required
	, 706 RoleID
	, 'Rookies' RoleName
	, NULL ExpirationDate
	, 'Add' [Action]
FROM #STH_Accounts sth
LEFT OUTER JOIN ods.SkiData_User_Roles sdur ON sth.SkiDataUserId = sdur.UserID AND sdur.RoleID = 706
WHERE sdur.ETL_ID IS NULL

INSERT INTO etl.SkiData_ExportFile_Roles (LRSUserID, TeamUniqueID, TicketAccountID, TicketUserID, RoleID, RoleName, ExpirationDate, [Action])
SELECT 
	sth.SkiDataUserId
	, '' TeamUniqueID 
	, CASE WHEN sth.SkiDataUserId IS NULL then sth.TicketAccountID ELSE null END TicketAccountID
	, null TicketUserID -- Not required
	, 707 RoleID
	, 'Starter' RoleName
	, NULL ExpirationDate
	, 'Add' [Action]
FROM #STH_Accounts sth
LEFT OUTER JOIN ods.SkiData_User_Roles sdur ON sth.SkiDataUserId = sdur.UserID AND sdur.RoleID = 707
WHERE sdur.ETL_ID IS NULL

INSERT INTO etl.SkiData_ExportFile_Roles (LRSUserID, TeamUniqueID, TicketAccountID, TicketUserID, RoleID, RoleName, ExpirationDate, [Action])
SELECT 
	sth.SkiDataUserId
	, '' TeamUniqueID 
	, CASE WHEN sth.SkiDataUserId IS NULL then sth.TicketAccountID ELSE null END TicketAccountID
	, null TicketUserID -- Not required
	, 708 RoleID
	, 'Veteran' RoleName
	, NULL ExpirationDate
	, 'Add' [Action]
FROM #STH_Accounts sth
LEFT OUTER JOIN ods.SkiData_User_Roles sdur ON sth.SkiDataUserId = sdur.UserID AND sdur.RoleID = 708
WHERE sdur.ETL_ID IS NULL


INSERT INTO etl.SkiData_ExportFile_Roles (LRSUserID, TeamUniqueID, TicketAccountID, TicketUserID, RoleID, RoleName, ExpirationDate, [Action])
SELECT 
	sth.SkiDataUserId
	, '' TeamUniqueID 
	, CASE WHEN sth.SkiDataUserId IS NULL then sth.TicketAccountID ELSE null END TicketAccountID
	, null TicketUserID -- Not required
	, 828 RoleID
	, 'Pro Bowler' RoleName
	, NULL ExpirationDate
	, 'Add' [Action]
FROM #STH_Accounts sth
LEFT OUTER JOIN ods.SkiData_User_Roles sdur ON sth.SkiDataUserId = sdur.UserID AND sdur.RoleID = 828
WHERE sdur.ETL_ID IS NULL


INSERT INTO etl.SkiData_ExportFile_Roles (LRSUserID, TeamUniqueID, TicketAccountID, TicketUserID, RoleID, RoleName, ExpirationDate, [Action])
SELECT 
	sth.SkiDataUserId
	, '' TeamUniqueID 
	, CASE WHEN sth.SkiDataUserId IS NULL then sth.TicketAccountID ELSE null END TicketAccountID
	, null TicketUserID -- Not required
	, 829 RoleID
	, 'Hall of Famer' RoleName
	, NULL ExpirationDate
	, 'Add' [Action]
FROM #STH_Accounts sth
LEFT OUTER JOIN ods.SkiData_User_Roles sdur ON sth.SkiDataUserId = sdur.UserID AND sdur.RoleID = 829
WHERE sdur.ETL_ID IS NULL
AND sth.PriceLevel NOT IN ( 'U', 'V', 'W' )



INSERT INTO etl.SkiData_ExportFile_ProfileProperties (LRSUserID, TeamUniqueID, TicketAccountID, TicketUserID, ProfileDefinitionID, ProfilePropertyName, ProfilePropertyText, LastUpdateDate)
SELECT 
	sth.SkiDataUserId
	, '' TeamUniqueID 
	, CASE WHEN sth.SkiDataUserId IS NULL then sth.TicketAccountID ELSE null END TicketAccountID
	, null TicketUserID -- Not required
	, 1472 ProfileDefinitionID
	, 'TicketAccountID' ProfilePropertyName
	, sth.TicketAccountID ProfilePropertyText
	, null LastUpdateDate
FROM #STH_Accounts sth
LEFT OUTER JOIN ods.SkiData_User_Profiles sdup ON sth.SkiDataUserId = sdup.UserID AND sdup.PropertyDefinitionId = 1472
WHERE sdup.ETL_ID IS NULL



INSERT INTO etl.SkiData_ExportFile_Points 
	( LRSUserID, TeamUniqueID, TicketAccountID, TicketUserID, PointActivityID, PointActivity, AwardDate, StaticPoints, PointFactor, Source, SourceID, SubAccountID, FriendlyDescription, Notes )

SELECT NULL LRSUserID, NULL TeamUniqueID, sth.TicketAccountID TicketAccountID, NULL TicketUserID, 1230 PointActivityID, 'Become an STM' PointActivity, GETDATE() AwardDate, 5000 StaticPoints, NULL PointFactor, 'TM' [Source], NULL SourceID, NULL SubAccountID, NULL FriendlyDescription, NULL Notes 
FROM #STH_Accounts sth
LEFT OUTER JOIN ods.SkiData_Points pta ON sth.TicketAccountID = pta.TicketAccountID AND pta.PointActivityID = 1230
LEFT OUTER JOIN ods.SkiData_Points psku ON sth.SkiDataUserId = psku.UserID AND psku.PointActivityID = 1230
WHERE pta.ETL_ID IS NULL AND psku.ETL_ID IS NULL 


INSERT INTO etl.SkiData_ExportFile_Points 
	( LRSUserID, TeamUniqueID, TicketAccountID, TicketUserID, PointActivityID, PointActivity, AwardDate, StaticPoints, PointFactor, Source, SourceID, SubAccountID, FriendlyDescription, Notes )

SELECT NULL LRSUserID, NULL TeamUniqueID, sth.TicketAccountID TicketAccountID, NULL TicketUserID, 1284 PointActivityID, 'Become an STM' PointActivity, GETDATE() AwardDate, 2500 StaticPoints, NULL PointFactor, 'TM' [Source], NULL SourceID, NULL SubAccountID, NULL FriendlyDescription, NULL Notes 
FROM #STH_Accounts sth
LEFT OUTER JOIN ods.SkiData_Points pta ON sth.TicketAccountID = pta.TicketAccountID AND pta.PointActivityID = 1230
LEFT OUTER JOIN ods.SkiData_Points psku ON sth.SkiDataUserId = psku.UserID AND psku.PointActivityID = 1230
LEFT OUTER JOIN ods.SkiData_Points pta2 ON sth.TicketAccountID = pta.TicketAccountID AND pta.PointActivityID = 1284
LEFT OUTER JOIN ods.SkiData_Points psku2 ON sth.SkiDataUserId = psku.UserID AND psku.PointActivityID = 1284
LEFT OUTER JOIN etl.SkiData_ExportFile_Points ptshof ON sth.TicketAccountID = ptshof.TicketAccountID AND ptshof.PointActivityID = 1230
WHERE pta.ETL_ID IS NULL AND psku.ETL_ID IS NULL 
AND pta2.ETL_ID IS NULL AND psku2.ETL_ID IS NULL
AND ptshof.TicketAccountID IS NULL

END


GO
