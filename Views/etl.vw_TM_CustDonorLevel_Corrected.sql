SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vw_TM_CustDonorLevel_Corrected]
AS

WITH FirstStep
AS (
	-- Remove records from CustDonorLevel WHERE drive_year is null and standardize donor level names
	SELECT cdl.acct_id
		, current_drive_year
		, drive_year
		, donor_level_set_name
		, COALESCE (
					REPLACE(REPLACE(cdl.honorary_donor_level, '_', ''), ' _', '')
				, REPLACE(REPLACE(cdl.donor_level, '_', ''), ' _', '')
				) donor_level
		, CASE WHEN REPLACE(REPLACE(cdl.honorary_donor_level, '_', ''), ' _', '') IS NOT NULL THEN 1 ELSE 0 END AS IsHonoraryDonor
			, cdl.qual_amount
			, REPLACE(REPLACE(cdl.current_donor_level, '_', ''), ' _', '') current_donor_level
			, REPLACE(REPLACE(cdl.next_donor_level, '_', ''), ' _', '') next_donor_level
			, cdl.amount_to_next_donor_level
	--SELECT COUNT(*)
	FROM ods.TM_CustDonorLevel cdl (NOLOCK)
	WHERE cdl.drive_year IS NOT NULL
)

, SecondStep
AS (
-- Add records for in-between drive years for Junior, Car Dealer, Lifetime, and Honorary members
	SELECT cdl.acct_id
		, cdl.current_drive_year
		, cdl.drive_year
		, cdl.drive_year AS initial_drive_year
		, cdl.donor_level_set_name
		, CASE WHEN cdl.donor_level = 'Full Scholar' THEN 'Full Scholarship'
			ELSE cdl.donor_level END AS donor_level
		, cdl.IsHonoraryDonor
		, cdl.qual_amount
		, cdl.current_donor_level
		, cdl.next_donor_level
		, cdl.amount_to_next_donor_level
	FROM FirstStep cdl
	WHERE cdl.donor_level NOT IN ('Junior', 'Car Dealer', 'Student', 'Lifetime Full', 'Lifetime Silver')
		AND cdl.IsHonoraryDonor = 0

	UNION ALL

	SELECT cdl.acct_id
		, cdl.current_drive_year
		, dy.drive_year
		, cdl.drive_year AS initial_drive_year
		, cdl.donor_level_set_name
		, cdl.donor_level
		, cdl.IsHonoraryDonor
		, cdl.qual_amount
		, cdl.current_donor_level
		, cdl.next_donor_level
		, cdl.amount_to_next_donor_level
	FROM FirstStep cdl
	JOIN (
			SELECT DISTINCT drive_year
			FROM ods.TM_CustDonorLevel (NOLOCK)
		) dy ON dy.drive_year BETWEEN cdl.drive_year AND cdl.current_drive_year
	WHERE cdl.donor_level IN ('Junior', 'Car Dealer', 'Student', 'Lifetime Full', 'Lifetime Silver')
		OR cdl.IsHonoraryDonor = 1
	--ORDER BY cdl.acct_id
)

, ThirdStep
AS (
	-- Add pledge and payment info
	SELECT cdl.acct_id
		, cdl.current_drive_year
		, cdl.drive_year
		, cdl.initial_drive_year
		, cdl.donor_level_set_name
		, cdl.donor_level
		, cdl.IsHonoraryDonor
		, cdl.qual_amount
		, cdl.current_donor_level
		, cdl.next_donor_level
		, cdl.amount_to_next_donor_level
		, ISNULL(SUM(d.original_pledge_amount), SUM(d.pledge_amount)) OriginalPledgeAmount
		, SUM(d.pledge_amount) PledgeAmount
		, SUM(CASE WHEN d.fund_name LIKE 'CAR%' AND d.donation_paid_amount = 0 THEN d.donor_level_amount_qual ELSE d.donation_paid_amount END) DonationPaidAmount
		, SUM(total_received_amount) TotalReceivedAmount
		, SUM(d.owed_amount) OwedAmount
		, SUM(d.external_paid_amount) ExternalPaidAmount
		, SUM(d.donor_level_amount_qual) DonorLevelAmountQual
	FROM SecondStep cdl
	LEFT JOIN ods.TM_Donation d (NOLOCK)
		ON cdl.acct_id = d.apply_to_acct_id
		AND cdl.drive_year = d.drive_year
	GROUP BY cdl.acct_id, cdl.current_drive_year, cdl.drive_year
		, cdl.initial_drive_year, cdl.donor_level_set_name, cdl.donor_level
		, cdl.IsHonoraryDonor, cdl.qual_amount, cdl.current_donor_level
		, cdl.next_donor_level, cdl.amount_to_next_donor_level
	--ORDER BY cdl.acct_id
)

, FourthStep
AS ( -- Null out the donor level on records where pledge amount > 0 and paid amount = 0
	SELECT a.acct_id
		, a.current_drive_year
		, a.drive_year
		, a.initial_drive_year
		, a.donor_level_set_name
		, CASE WHEN ISNULL(a.OriginalPledgeAmount, 0) > 0 AND ISNULL(a.DonationPaidAmount, 0) = 0 THEN NULL
			ELSE a.donor_level END AS donor_level
		, a.IsHonoraryDonor
		, a.qual_amount
		, a.current_donor_level
		, a.next_donor_level
		, a.amount_to_next_donor_level
		, a.OriginalPledgeAmount
		, a.PledgeAmount
		, a.DonationPaidAmount
		, a.TotalReceivedAmount
		, a.OwedAmount
		, a.ExternalPaidAmount
	FROM ThirdStep a
)

, LFPY
AS (
	SELECT d.apply_to_acct_id AS acct_id
		, d.fund_name
		, CASE WHEN d.donation_paid_amount BETWEEN 500 AND 999.99 THEN 'Lifetime Full'
			WHEN d.donation_paid_amount >= 1000 THEN 'Lifetime Silver'
			END AS Donor_Level
		, SUM(d.original_pledge_amount) Original_Pledge_Amount
		, SUM(d.pledge_amount) Pledge_Amount
		, SUM(d.donation_paid_amount) Donation_Paid_Amount
		, SUM(d.total_received_amount) Total_Received_Amount
		, SUM(d.owed_amount) Owed_Amount
		, SUM(d.external_paid_amount) External_Paid_Amount
		, MIN(d.payment_schedule_id) Payment_schedule_id
	FROM ods.TM_Donation d (NOLOCK)
	WHERE d.drive_year = 2018
		AND d.fund_name LIKE 'LFPY%'
	GROUP BY d.apply_to_acct_id, d.fund_name
		, CASE WHEN d.donation_paid_amount BETWEEN 500 AND 999.99 THEN 'Lifetime Full'
			WHEN d.donation_paid_amount >= 1000 THEN 'Lifetime Silver'
			END
	)

SELECT a.acct_id
	, a.current_drive_year
	, a.drive_year
	, a.initial_drive_year
	, a.donor_level_set_name
	, COALESCE(b.Donor_Level, a.donor_level) donor_level
	, a.IsHonoraryDonor
	, a.qual_amount
	, a.current_donor_level
	, a.next_donor_level
	, a.amount_to_next_donor_level
	, a.OriginalPledgeAmount
	, a.PledgeAmount
	, a.DonationPaidAmount
	, a.TotalReceivedAmount
	, a.OwedAmount
	, a.ExternalPaidAmount
	, RANK() OVER(PARTITION BY a.acct_id, a.drive_year ORDER BY
			(CASE   WHEN a.donor_level = 'Lifetime Silver' THEN 1
					WHEN a.donor_level = 'Lifetime Full' THEN 3
					--WHEN a.donor_level = 'Car Dealer' THEN 4
					WHEN a.donor_level = 'Diamond Spur' THEN 5
					WHEN a.donor_level = 'Platinum Spur' THEN 7
					WHEN a.donor_level = 'Golden Spur' THEN 9
					WHEN a.donor_level = 'Garnet Spur' THEN 11
					WHEN a.donor_level = 'Silver Spur' THEN 13
					WHEN a.donor_level = 'Full Scholarship' THEN 15
					WHEN a.donor_level = 'Half Scholarship' THEN 17
					WHEN a.donor_level = 'Roundhouse' THEN 19
					WHEN a.donor_level = 'Century' THEN 21
					WHEN a.donor_level = 'Roost' THEN 23
					WHEN a.donor_level = 'Car Dealer' THEN 25
					WHEN a.donor_level = 'Student' THEN 27
					WHEN a.donor_level = 'Junior' THEN 29
				END)) xRank
FROM FourthStep a
LEFT JOIN LFPY b
	ON a.acct_id = b.acct_id
WHERE (CASE WHEN a.donor_level NOT IN ('Lifetime Full', 'Lifetime Silver') AND ISNULL(a.OriginalPledgeAmount, 0) = 0
			THEN 1 ELSE 0 END) <> 1
	AND a.donor_level IS NOT NULL
    






GO
