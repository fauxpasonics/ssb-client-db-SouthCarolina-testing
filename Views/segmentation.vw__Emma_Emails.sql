SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [segmentation].[vw__Emma_Emails]
AS

SELECT DISTINCT ssbid.SSB_CRMSYSTEM_CONTACT_ID
	, pc.emma__Emma_Member_ID__c AS EmmaMemberID
	, ee.emma__Member_Type__c AS EmmaMemberType
	, pc.emma__Last_Synced_Date__c AS EmmaLastSyncedDate
	, pc.emma__Bounced__c AS EmmaBounced
	, ee.[Name] EmmaEmailName
	, ee.emma__Opened__c EmmaEmailOpened
	, eg.[Name] EmmaGroupName
	, em.[Name] EmmaMailingName
	, em.emma__Email_Subject__c EmmaEmailSubject
	, ee.emma__Summary_Num_of_Clicks__c CountClicks
	, ee.emma__Summary_Num_of_Opens__c CountOpens
	, ee.emma__Summary_Num_of_Shares__c CountShares
	, ee.emma__Summary_Num_of_Forwards__c CountForwards
	--, eml.emma__Link_Name__c LinkName
FROM dbo.dimcustomerssbid ssbid
JOIN SouthCarolina_Reporting.prodcopy.contact pc ON ssbid.ssid = pc.Id
JOIN SouthCarolina_Reporting.prodcopy.Emma__Emma_Email__c ee
	ON pc.id = ee.emma__Contact__c
JOIN SouthCarolina_Reporting.prodcopy.Emma__Emma_Mailing__c em
	ON ee.emma__Emma_Mailing__c = em.ID
LEFT JOIN (
	SELECT egm.emma__Contact__c, eg.[Name]
	FROM SouthCarolina_Reporting.prodcopy.Emma__Emma_Group_Member__c egm
	JOIN SouthCarolina_Reporting.prodcopy.Emma__Emma_Group__c eg ON egm.emma__Emma_Group__c = eg.Id
	) eg ON pc.id = eg.emma__Contact__c
--LEFT JOIN SouthCarolina_Reporting.prodcopy.Emma__Mailing_Link__c eml
--	ON em.ID = eml.emma__Emma_Mailing__c



GO
