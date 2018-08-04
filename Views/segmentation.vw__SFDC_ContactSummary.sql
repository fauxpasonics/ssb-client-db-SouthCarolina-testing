SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE VIEW [segmentation].[vw__SFDC_ContactSummary] AS


SELECT contact.SSB_CRMSYSTEM_CONTACT_ID__c AS SSB_CRMSYSTEM_CONTACT_ID
	  ,Contact.Id AS SFDC_ContactID
	  , contact.accountid AS SFDC_AccountID
	  ,contact.Name
	  ,contact.CreatedDate
	  ,contact.CreatedById
	  ,createdUser.name AS CreatedByName
	  ,contact.LastModifiedDate
	  ,contact.LastModifiedById
	  ,contact.OwnerId
	  ,contactOwner.Name OwnerName
	  ,contact.LastActivityDate
	  ,DATEDIFF(DAY,contact.LastActivityDate,GETDATE()) DaysSinceLastActivity
	  --,LastActivityOwner /*this requires prodcopy.task to be imported*/
	  , OpenOpp.OpenOpp AS HasOpenOpportunity
	  ,LastOpportunity.CreatedDate AS LastOpportunityCreatedDate
	  ,LastOpportunity.OwnerName AS LastOpportunityOwnerName
	  ,LastOpportunity.LastModifiedDate AS LastOpportunityLastModifiedDate
	  ,lastWon.LastWinDate AS LastOpportunityClosedWonDate
	  ,LastLost.LostReason AS LastOpportunityClosedLostReason
	  ,contact.[SSB_CRMSYSTEM_Last_Ticket_Purchase_Date__c] AS LastTicketPurchaseDate
	  ,contact.[SSB_CRMSYSTEM_Last_Donation_Date__c] AS LastDonationDate
	  ,contact.[SSB_CRMSYSTEM_Donor_Warning__c] AS DonorWarningFlag
	  ,contact.[SSB_CRMSYSTEM_Total_Priority_Points__c] AS TotalPriorityPoints
	  ,contact.[SSB_CRMSYSTEM_Football_STH__c] AS FootballSTH
	  ,contact.[SSB_CRMSYSTEM_Football_Rookie__c] AS FootballRookie
	  ,contact.[SSB_CRMSYSTEM_Football_Partial__c] AS FootballPartial
	  ,contact.[SSB_CRMSYSTEM_Mens_Basketball_STH__c] AS MBBSTH
	  ,contact.[SSB_CRMSYSTEM_Mens_Basketball_Rookie__c] AS MBBRookie
	  ,contact.[SSB_CRMSYSTEM_Mens_Basketball_Partial__c] AS MBBPartial
	  ,contact.[SSB_CRMSYSTEM_CY_Donation_Level__c] AS CY_DonationLevel
	  ,contact.[SSB_CRMSYSTEM_CY_Donation_Amount__c] AS CY_DonationAmount
	  ,contact.[SSB_CRMSYSTEM_CY_Donation_Upsell__c] AS CY_DonationUpsell
	  ,contact.[SSB_CRMSYSTEM_CorporateBuyer_Flag__c] AS CorporateBuyerFlag
	  ,contact.[SSB_CRMSYSTEM_Company_Name__c] AS CompanyName
	  ,contact.[SSB_CRMSYSTEM_CLA_CC11_16_Group_Buyer__c] AS CLA_GroupBuyer
	  ,contact.[SSB_CRMSYSTEM_CLA_CC11_16_Premium_Buyer__c] AS CLA_PremiumBuyer
	  ,contact.[SSB_CRMSYSTEM_CLA_CC11_16_Total_Spend__c] AS CLA_TotalSpend
	  ,Contact.[HasOptedOutOfEmail]
	  ,Contact.[emma__Sync_Status__c]
 FROM SouthCarolina_Reporting.[ProdCopy].[Contact] (NOLOCK) contact
	 INNER JOIN  (SELECT SSB_CRMSYSTEM_CONTACT_ID__c, Id, ROW_NUMBER() OVER(PARTITION BY SSB_CRMSYSTEM_CONTACT_ID__c ORDER BY LastModifiedDate DESC, CreatedDate) xRank 
					FROM SouthCarolina_Reporting.[prodcopy].[vw_Contact]) x
					ON contact.Id = x.Id AND x.xRank = '1'
	LEFT JOIN SouthCarolina_Reporting.ProdCopy.[USER] (NOLOCK) createdUser ON createdUser.ID =contact.CreatedById
	LEFT JOIN SouthCarolina_Reporting.ProdCopy.[user] (NOLOCK) contactOwner ON contactowner.Id = contact.OwnerId
	LEFT JOIN (SELECT opportunity.contact_name__c
			   		 ,opportunity.CreatedDate
			   		 ,[user].Name OwnerName
			   		 ,opportunity.LastModifiedDate
					 ,RANK() OVER(PARTITION BY opportunity.contact_name__c ORDER BY opportunity.Id) opportunityRank
			   FROM SouthCarolina_Reporting.ProdCopy.Opportunity (NOLOCK) opportunity
				JOIN (SELECT contact_name__c
							,MAX(CreatedDate)MaxDate
					  FROM SouthCarolina_Reporting.ProdCopy.Opportunity (NOLOCK)
					  GROUP BY contact_name__c
					  )x
					  ON x.contact_name__c = opportunity.contact_name__c
						AND x.MaxDate = opportunity.CreatedDate
			   	LEFT JOIN SouthCarolina_Reporting.ProdCopy.[user] (NOLOCK) [user]
			   		ON [user].Id = opportunity.OwnerId
				)LastOpportunity
				ON LastOpportunity.contact_name__c = contact.Id
				   AND LastOpportunity.opportunityRank = 1
		LEFT JOIN (SELECT contact_name__c, MAX(LastModifiedDate)OpenOpp
			   FROM SouthCarolina_Reporting.ProdCopy.Opportunity (NOLOCK)
			   WHERE isClosed = 0 
			   GROUP BY contact_name__c) OpenOpp ON OpenOpp.contact_name__c = contact.Id
	LEFT JOIN (SELECT contact_name__c
					  ,MAX(CreatedDate)LastWinDate 
			   FROM SouthCarolina_Reporting.ProdCopy.Opportunity (NOLOCK)
			   WHERE isClosed = 1 AND IsWon = 1
			   GROUP BY contact_name__c) LastWon ON LastWon.contact_name__c = contact.Id
	LEFT JOIN (SELECT Opportunity.contact_name__c
					  ,Reason_Lost__c LostReason
					  ,RANK() OVER(PARTITION BY opportunity.contact_name__c ORDER BY opportunity.Id) opportunityRank
			   FROM SouthCarolina_Reporting.ProdCopy.Opportunity (NOLOCK)
					JOIN (SELECT contact_name__c
								,MAX(CreatedDate) AS LastLoss
						  FROM SouthCarolina_Reporting.ProdCopy.Opportunity (NOLOCK)
						  WHERE isClosed = 1 AND IsWon = 0
						  GROUP BY contact_name__c)LastLoss ON LastLoss.contact_name__c = Opportunity.contact_name__c
														 AND LastLoss.LastLoss = Opportunity.CreatedDate
			   ) LastLost ON LastLost.contact_name__c = contact.Id	
							 AND LastLost.opportunityRank = 1	

	WHERE contact.SSB_CRMSYSTEM_CONTACT_ID__c IS NOT null


	--244,146





GO
