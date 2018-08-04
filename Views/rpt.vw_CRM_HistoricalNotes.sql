SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE VIEW [rpt].[vw_CRM_HistoricalNotes] as 
(

select x.SFDCID as SalesforceContactId
, CASE WHEN CRM_User = 'IMGGM' THEN '00541000001jIypAAE'
	   WHEN CRM_User = 'DONAHUEK' THEN '00541000001lTg6AAE'
	   WHEN CRM_User = 'CHAZCH'   THEN '00541000001lTfwAAE'
	   WHEN CRM_User = 'BLAKEW' THEN '00541000001lTfhAAE'
	   WHEN CRM_User = 'CLAYTON' THEN '00541000001lTg1AAE'
	   WHEN CRM_User = 'MATTSEU' THEN '00541000001lTgGAAU' ELSE '00541000000vCzJAAU' END AS Assigned_To
, CRM_User  +  ''   +  ' '  + Comments1 AS Comments
,'Other' as Type
, *
from (select c.Id AS SFDCID
, tmn.id as Note_id
,CASE WHEN task_assigned_to_user_id <> '' THEN task_assigned_to_user_id
	   WHEN task_assigned_to_user_id = '' AND upd_user <> '' THEN [upd_user]
	   ELSE add_user END AS  CRM_User
, CAST(upd_DateTime AS DATE) as Date_Due
, CASE WHEN note_type = 'T' THEN text 
       WHEN note_Type = 'M' THEN contact_Category END AS Activity_Subject
, CASE WHEN task_activity like 'E-mail%' THEN 'Email'
		WHEN task_activity like '%Call%' THEN 'Phone'
		ELSE 'Other' END AS Activity_Type
, CASE WHEN task_stage_status = 'Open' THEN 'No Attempt'
		WHEN task_stage_status IN ('Waiting on Customer', 'Waiting on Internal Party') THEN 'Waiting on someone else'
		WHEN task_stage_status IN ('Pending', 'Work in Progress') THEN '1st Attempt'
		ELSE 'Completed' END AS Status
, task_stage_text as Comments1
, CASE WHEN [priority] IN ('Critical', 'High', 'VIP') THEN 'High'
		ELSE 'Normal' END as CRM_Priority
, c.Name
 , dc.AccountId
, c.SSB_CRMSYSTEM_CONTACT_ID__c
, dc.SSB_CRMSYSTEM_CONTACT_ID
 from [ods].[TM_Note] tmn WITH (NOLOCK)
JOIN [dbo].[vwDimCustomer_ModAcctId] dc WITH (NOLOCK) on dc.SourceSystem = 'TM' and tmn.acct_id = dc.accountid and dc.CustomerType = 'Primary'
LEFT JOIN SSBCIDW04.SouthCarolina_Reporting.[prodcopy].[vw_Contact] c WITH (NOLOCK) on dc.SSB_CRMSYSTEM_CONTACT_ID = c.[SSB_CRMSYSTEM_CONTACT_ID__c]
where upd_Datetime > '2013-06-30 12:04:38.897')x

)








GO
