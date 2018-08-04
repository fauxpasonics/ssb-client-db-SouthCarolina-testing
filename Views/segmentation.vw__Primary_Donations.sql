SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [segmentation].[vw__Primary_Donations]
AS

WITH DonorLevel
AS (
	SELECT acct_id, drive_year, MAX(cust_donor_level_id) cust_donor_level_id
	FROM ods.TM_CustDonorLevel
	GROUP BY acct_id, drive_year
	)

SELECT ssbid.SSB_CRMSYSTEM_CONTACT_ID
	, don.acct_id Archtics_ID
	, don.Pledge_Datetime
	, don.Fund_ID
	, don.Fund_Name
	, don.Fund_Desc
	, don.Drive_Year
	, don.Donation_Type_Name
	, don.Solicitation_Name
	, don.Solicitation_Category_Name
	, don.Contact_Type
	, don.Gl_Code
	, don.Active
	, don.Qual_For_Benefits
	, don.Original_Pledge_Amount
	, don.Pledge_Amount
	, don.Donation_Paid_Amount
	, don.Total_Received_Amount
	, don.Owed_Amount
	, don.External_Paid_Amount
	, don.Donor_Level_Amount_Qual
	, don.Donor_Level_Amount_Not_Qual
	, don.Donor_Level_Amount_Qual_Apply_To_Acct
	, don.Donor_Level_Amount_Not_Qual_Apply_To_Acct
	, don.[Anonymous]
	, don.[Source]
	, don.[Points]
	, don.Donor_Level_Set_Name
	, COALESCE(dl.honorary_donor_level, dl.donor_level) Donor_Level
FROM ods.tm_donation don
LEFT JOIN (
	SELECT DISTINCT cdl. acct_id, cdl.drive_year, cdl.honorary_donor_level, cdl.donor_level, cdl.qual_amount
		, cdl.next_donor_level, cdl.amount_to_next_donor_level, cdl.[start_date], cdl.end_date
	FROM ods.TM_CustDonorLevel cdl
	JOIN DonorLevel dl
		ON cdl.acct_id = dl.acct_id
		AND cdl.drive_year = dl.Drive_Year
		AND cdl.cust_donor_level_id = dl.cust_donor_level_id
	) dl ON don.apply_to_acct_id = dl.acct_id
	AND dl.drive_year = don.drive_year
JOIN dbo.DimCustomer dc
	ON don.apply_to_acct_id = dc.AccountId
	AND dc.SourceSystem = 'TM'
	AND dc.CustomerType = 'Primary'
JOIN dbo.dimcustomerssbid ssbid
	ON dc.DimCustomerId = ssbid.DimCustomerId
WHERE don.drive_year >= 2010











GO
