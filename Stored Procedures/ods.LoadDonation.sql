SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [ods].[LoadDonation]
(
	@BatchId INT = 0,
	@Options NVARCHAR(MAX) = null
)
AS 

BEGIN
/**************************************Comments***************************************
**************************************************************************************
Mod #:  1
Name:     dbo
Date:     11/22/2016
Comments: Initial creation
*************************************************************************************/

DECLARE @RunTime DATETIME = GETDATE()

DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @ProcedureName nvarchar(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.TM_Donation),'0');	
DECLARE @SrcDataSize NVARCHAR(255) = '0'

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Start', @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Row Count', @SrcRowCount, @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src DataSize', @SrcDataSize, @ExecutionId

SELECT CAST(NULL AS BINARY(32)) ETL_DeltaHashKey, SourceFileName, ISNULL(TRY_CAST(cust_donation_id AS int),0) cust_donation_id, name_last, name_last_first_mi, company_name, ISNULL(TRY_CAST(acct_id AS int),0) acct_id, ISNULL(TRY_CAST(order_num AS int),0) order_num, ISNULL(TRY_CAST(order_line_item AS int),0) order_line_item, ISNULL(TRY_CAST(order_line_item_seq AS int),0) order_line_item_seq, donation_type, donation_type_name, ISNULL(TRY_CAST(active AS bit),0) active, ISNULL(TRY_CAST(fund_id AS int),0) fund_id, fund_name, ISNULL(TRY_CAST(qual_for_benefits AS bit),0) qual_for_benefits, ISNULL(TRY_CAST(drive_year AS int),0) drive_year, fund_desc, campaign_id, campaign_name, gl_code, ISNULL(TRY_CAST(solicitation_id AS int),0) solicitation_id, solicitation_name, solicitation_category, solicitation_category_name, contact_type_code, contact_type, ISNULL(TRY_CAST(pledge_used_for_mg AS bit),0) pledge_used_for_mg, soft_credit_type, soft_credit_name, gift_in_kind_type, gift_in_kind_name, ISNULL(TRY_CAST(original_pledge_amount AS decimal(18,6)),0) original_pledge_amount, ISNULL(TRY_CAST(pledge_amount AS decimal(18,6)),0) pledge_amount, ISNULL(TRY_CAST(donation_paid_amount AS decimal(18,6)),0) donation_paid_amount, ISNULL(TRY_CAST(total_received_amount AS decimal(18,6)),0) total_received_amount, ISNULL(TRY_CAST(owed_amount AS decimal(18,6)),0) owed_amount, ISNULL(TRY_CAST(external_paid_amount AS decimal(18,6)),0) external_paid_amount, payment_schedule_id, ISNULL(TRY_CAST(donor_level_amount_qual AS decimal(18,6)),0) donor_level_amount_qual, ISNULL(TRY_CAST(donor_level_amount_not_qual AS decimal(18,6)),0) donor_level_amount_not_qual, ISNULL(TRY_CAST(anonymous AS bit),0) anonymous, source, comments, cust_donation_info_1, cust_donation_info_2, cust_donation_info_3, cust_donation_info_4, cust_donation_info_5, cust_donation_info_6, cust_donation_info_7, cust_donation_info_8, cust_donation_info_9, cust_donation_info_10, cust_donation_info_11, cust_donation_info_12, cust_donation_info_13, cust_donation_info_14, cust_donation_info_15, cust_donation_info_16, cust_donation_info_17, cust_donation_info_18, cust_donation_info_19, cust_donation_info_20, patron_listing_name, TRY_CAST(expected_payment_date AS datetime) expected_payment_date, matching_gift_corp_name, matching_gift_comment, corp_donation_match_used_amount, thank_you_letter_id, thank_you_letter, TRY_CAST(thank_you_letter_datetime AS datetime) thank_you_letter_datetime, TRY_CAST(tax_form_sent_datetime AS datetime) tax_form_sent_datetime, matched_acct_id, matched_order_num, matched_oli, matched_olis, TRY_CAST(renewal_date AS datetime) renewal_date, ISNULL(TRY_CAST(points AS decimal(18,6)),0) points, orig_cust_donation_id, add_user, TRY_CAST(add_datetime AS datetime) add_datetime, upd_user, TRY_CAST(upd_datetime AS datetime) upd_datetime, TRY_CAST(donation_paid_datetime AS datetime) donation_paid_datetime, merchant_code, ledger_code, name_type, owner_name, owner_name_full, TRY_CAST(pledge_datetime AS datetime) pledge_datetime, donation_category, ISNULL(TRY_CAST(cust_name_id AS int),0) cust_name_id, donor_name, donor_name_full, stock_symbol, stock_num_shares, TRY_CAST(stock_cert_num AS datetime) stock_cert_num, TRY_CAST(stock_transfer_datetime AS datetime) stock_transfer_datetime, TRY_CAST(stock_transfer_date_low_price AS datetime) stock_transfer_date_low_price, TRY_CAST(stock_transfer_date_high_price AS datetime) stock_transfer_date_high_price, TRY_CAST(stock_transfer_date_avg_price AS datetime) stock_transfer_date_avg_price, stock_sales_amt, stock_broker_fee, assoc_cust_donation_Id, suggested_amount, apply_to_email_addr, ISNULL(TRY_CAST(apply_to_acct_id AS int),0) apply_to_acct_id, TRY_CAST(claim_datetime AS datetime) claim_datetime, in_memory_of_name, matching_gift_contact_name, matching_gift_contact_email, matching_gift_contact_phone, ISNULL(TRY_CAST(donor_level_amount_qual_apply_to_acct AS decimal(18,6)),0) donor_level_amount_qual_apply_to_acct, ISNULL(TRY_CAST(donor_level_amount_not_qual_apply_to_acct AS decimal(18,6)),0) donor_level_amount_not_qual_apply_to_acct, owner_name_apply_to_acct, ISNULL(TRY_CAST(unclaimed_credits AS bit),0) unclaimed_credits, apply_to_acct_id_display, owner_name_apply_to_acct_display, TRY_CAST(pledge_expiration_date AS datetime) pledge_expiration_date, ISNULL(TRY_CAST(waive_benefit_ind AS bit),0) waive_benefit_ind, ISNULL(TRY_CAST(donor_level_set_id AS int),0) donor_level_set_id, donor_level_set_name, ISNULL(TRY_CAST(donor_level_calculated_ind AS bit),0) donor_level_calculated_ind, apply_to_name_First, apply_to_name_last, language_name, ISNULL(TRY_CAST(seq_num AS int),0) seq_num
INTO #SrcData
FROM src.TM_Donation


EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(acct_id),'DBNULL_TEXT') + ISNULL(RTRIM(active),'DBNULL_TEXT') + ISNULL(RTRIM(add_datetime),'DBNULL_TEXT') + ISNULL(RTRIM(add_user),'DBNULL_TEXT') + ISNULL(RTRIM(anonymous),'DBNULL_TEXT') + ISNULL(RTRIM(apply_to_acct_id),'DBNULL_TEXT') + ISNULL(RTRIM(apply_to_acct_id_display),'DBNULL_TEXT') + ISNULL(RTRIM(apply_to_email_addr),'DBNULL_TEXT') + ISNULL(RTRIM(apply_to_name_First),'DBNULL_TEXT') + ISNULL(RTRIM(apply_to_name_last),'DBNULL_TEXT') + ISNULL(RTRIM(assoc_cust_donation_Id),'DBNULL_TEXT') + ISNULL(RTRIM(campaign_id),'DBNULL_TEXT') + ISNULL(RTRIM(campaign_name),'DBNULL_TEXT') + ISNULL(RTRIM(claim_datetime),'DBNULL_TEXT') + ISNULL(RTRIM(comments),'DBNULL_TEXT') + ISNULL(RTRIM(company_name),'DBNULL_TEXT') + ISNULL(RTRIM(contact_type),'DBNULL_TEXT') + ISNULL(RTRIM(contact_type_code),'DBNULL_TEXT') + ISNULL(RTRIM(corp_donation_match_used_amount),'DBNULL_TEXT') + ISNULL(RTRIM(cust_donation_id),'DBNULL_TEXT') + ISNULL(RTRIM(cust_donation_info_1),'DBNULL_TEXT') + ISNULL(RTRIM(cust_donation_info_10),'DBNULL_TEXT') + ISNULL(RTRIM(cust_donation_info_11),'DBNULL_TEXT') + ISNULL(RTRIM(cust_donation_info_12),'DBNULL_TEXT') + ISNULL(RTRIM(cust_donation_info_13),'DBNULL_TEXT') + ISNULL(RTRIM(cust_donation_info_14),'DBNULL_TEXT') + ISNULL(RTRIM(cust_donation_info_15),'DBNULL_TEXT') + ISNULL(RTRIM(cust_donation_info_16),'DBNULL_TEXT') + ISNULL(RTRIM(cust_donation_info_17),'DBNULL_TEXT') + ISNULL(RTRIM(cust_donation_info_18),'DBNULL_TEXT') + ISNULL(RTRIM(cust_donation_info_19),'DBNULL_TEXT') + ISNULL(RTRIM(cust_donation_info_2),'DBNULL_TEXT') + ISNULL(RTRIM(cust_donation_info_20),'DBNULL_TEXT') + ISNULL(RTRIM(cust_donation_info_3),'DBNULL_TEXT') + ISNULL(RTRIM(cust_donation_info_4),'DBNULL_TEXT') + ISNULL(RTRIM(cust_donation_info_5),'DBNULL_TEXT') + ISNULL(RTRIM(cust_donation_info_6),'DBNULL_TEXT') + ISNULL(RTRIM(cust_donation_info_7),'DBNULL_TEXT') + ISNULL(RTRIM(cust_donation_info_8),'DBNULL_TEXT') + ISNULL(RTRIM(cust_donation_info_9),'DBNULL_TEXT') + ISNULL(RTRIM(cust_name_id),'DBNULL_TEXT') + ISNULL(RTRIM(donation_category),'DBNULL_TEXT') + ISNULL(RTRIM(donation_paid_amount),'DBNULL_TEXT') + ISNULL(RTRIM(donation_paid_datetime),'DBNULL_TEXT') + ISNULL(RTRIM(donation_type),'DBNULL_TEXT') + ISNULL(RTRIM(donation_type_name),'DBNULL_TEXT') + ISNULL(RTRIM(donor_level_amount_not_qual),'DBNULL_TEXT') + ISNULL(RTRIM(donor_level_amount_not_qual_apply_to_acct),'DBNULL_TEXT') + ISNULL(RTRIM(donor_level_amount_qual),'DBNULL_TEXT') + ISNULL(RTRIM(donor_level_amount_qual_apply_to_acct),'DBNULL_TEXT') + ISNULL(RTRIM(donor_level_calculated_ind),'DBNULL_TEXT') + ISNULL(RTRIM(donor_level_set_id),'DBNULL_TEXT') + ISNULL(RTRIM(donor_level_set_name),'DBNULL_TEXT') + ISNULL(RTRIM(donor_name),'DBNULL_TEXT') + ISNULL(RTRIM(donor_name_full),'DBNULL_TEXT') + ISNULL(RTRIM(drive_year),'DBNULL_TEXT') + ISNULL(RTRIM(expected_payment_date),'DBNULL_TEXT') + ISNULL(RTRIM(external_paid_amount),'DBNULL_TEXT') + ISNULL(RTRIM(fund_desc),'DBNULL_TEXT') + ISNULL(RTRIM(fund_id),'DBNULL_TEXT') + ISNULL(RTRIM(fund_name),'DBNULL_TEXT') + ISNULL(RTRIM(gift_in_kind_name),'DBNULL_TEXT') + ISNULL(RTRIM(gift_in_kind_type),'DBNULL_TEXT') + ISNULL(RTRIM(gl_code),'DBNULL_TEXT') + ISNULL(RTRIM(in_memory_of_name),'DBNULL_TEXT') + ISNULL(RTRIM(language_name),'DBNULL_TEXT') + ISNULL(RTRIM(ledger_code),'DBNULL_TEXT') + ISNULL(RTRIM(matched_acct_id),'DBNULL_TEXT') + ISNULL(RTRIM(matched_oli),'DBNULL_TEXT') + ISNULL(RTRIM(matched_olis),'DBNULL_TEXT') + ISNULL(RTRIM(matched_order_num),'DBNULL_TEXT') + ISNULL(RTRIM(matching_gift_comment),'DBNULL_TEXT') + ISNULL(RTRIM(matching_gift_contact_email),'DBNULL_TEXT') + ISNULL(RTRIM(matching_gift_contact_name),'DBNULL_TEXT') + ISNULL(RTRIM(matching_gift_contact_phone),'DBNULL_TEXT') + ISNULL(RTRIM(matching_gift_corp_name),'DBNULL_TEXT') + ISNULL(RTRIM(merchant_code),'DBNULL_TEXT') + ISNULL(RTRIM(name_last),'DBNULL_TEXT') + ISNULL(RTRIM(name_last_first_mi),'DBNULL_TEXT') + ISNULL(RTRIM(name_type),'DBNULL_TEXT') + ISNULL(RTRIM(order_line_item),'DBNULL_TEXT') + ISNULL(RTRIM(order_line_item_seq),'DBNULL_TEXT') + ISNULL(RTRIM(order_num),'DBNULL_TEXT') + ISNULL(RTRIM(orig_cust_donation_id),'DBNULL_TEXT') + ISNULL(RTRIM(original_pledge_amount),'DBNULL_TEXT') + ISNULL(RTRIM(owed_amount),'DBNULL_TEXT') + ISNULL(RTRIM(owner_name),'DBNULL_TEXT') + ISNULL(RTRIM(owner_name_apply_to_acct),'DBNULL_TEXT') + ISNULL(RTRIM(owner_name_apply_to_acct_display),'DBNULL_TEXT') + ISNULL(RTRIM(owner_name_full),'DBNULL_TEXT') + ISNULL(RTRIM(patron_listing_name),'DBNULL_TEXT') + ISNULL(RTRIM(payment_schedule_id),'DBNULL_TEXT') + ISNULL(RTRIM(pledge_amount),'DBNULL_TEXT') + ISNULL(RTRIM(pledge_datetime),'DBNULL_TEXT') + ISNULL(RTRIM(pledge_expiration_date),'DBNULL_TEXT') + ISNULL(RTRIM(pledge_used_for_mg),'DBNULL_TEXT') + ISNULL(RTRIM(points),'DBNULL_TEXT') + ISNULL(RTRIM(qual_for_benefits),'DBNULL_TEXT') + ISNULL(RTRIM(renewal_date),'DBNULL_TEXT') + ISNULL(RTRIM(seq_num),'DBNULL_TEXT') + ISNULL(RTRIM(soft_credit_name),'DBNULL_TEXT') + ISNULL(RTRIM(soft_credit_type),'DBNULL_TEXT') + ISNULL(RTRIM(solicitation_category),'DBNULL_TEXT') + ISNULL(RTRIM(solicitation_category_name),'DBNULL_TEXT') + ISNULL(RTRIM(solicitation_id),'DBNULL_TEXT') + ISNULL(RTRIM(solicitation_name),'DBNULL_TEXT') + ISNULL(RTRIM(source),'DBNULL_TEXT') + ISNULL(RTRIM(SourceFileName),'DBNULL_TEXT') + ISNULL(RTRIM(stock_broker_fee),'DBNULL_TEXT') + ISNULL(RTRIM(stock_cert_num),'DBNULL_TEXT') + ISNULL(RTRIM(stock_num_shares),'DBNULL_TEXT') + ISNULL(RTRIM(stock_sales_amt),'DBNULL_TEXT') + ISNULL(RTRIM(stock_symbol),'DBNULL_TEXT') + ISNULL(RTRIM(stock_transfer_date_avg_price),'DBNULL_TEXT') + ISNULL(RTRIM(stock_transfer_date_high_price),'DBNULL_TEXT') + ISNULL(RTRIM(stock_transfer_date_low_price),'DBNULL_TEXT') + ISNULL(RTRIM(stock_transfer_datetime),'DBNULL_TEXT') + ISNULL(RTRIM(suggested_amount),'DBNULL_TEXT') + ISNULL(RTRIM(tax_form_sent_datetime),'DBNULL_TEXT') + ISNULL(RTRIM(thank_you_letter),'DBNULL_TEXT') + ISNULL(RTRIM(thank_you_letter_datetime),'DBNULL_TEXT') + ISNULL(RTRIM(thank_you_letter_id),'DBNULL_TEXT') + ISNULL(RTRIM(total_received_amount),'DBNULL_TEXT') + ISNULL(RTRIM(unclaimed_credits),'DBNULL_TEXT') + ISNULL(RTRIM(upd_datetime),'DBNULL_TEXT') + ISNULL(RTRIM(upd_user),'DBNULL_TEXT') + ISNULL(RTRIM(waive_benefit_ind),'DBNULL_TEXT'))

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'ETL_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (cust_donation_id)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId


--DECLARE @RunTime DATETIME = GETDATE()

MERGE ods.TM_Donation AS myTarget

USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON myTarget.cust_donation_id = mySource.cust_donation_id

WHEN MATCHED AND (
     ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.HashKey, -1)
	 
)
THEN UPDATE SET
     myTarget.[UpdateDate] = @RunTime
     ,myTarget.[SourceFileName] = mySource.[SourceFileName]
     ,myTarget.[HashKey] = mySource.ETL_DeltaHashKey
     ,myTarget.[cust_donation_id] = mySource.[cust_donation_id]
     ,myTarget.[name_last] = mySource.[name_last]
     ,myTarget.[name_last_first_mi] = mySource.[name_last_first_mi]
     ,myTarget.[company_name] = mySource.[company_name]
     ,myTarget.[acct_id] = mySource.[acct_id]
     ,myTarget.[order_num] = mySource.[order_num]
     ,myTarget.[order_line_item] = mySource.[order_line_item]
     ,myTarget.[order_line_item_seq] = mySource.[order_line_item_seq]
     ,myTarget.[donation_type] = mySource.[donation_type]
     ,myTarget.[donation_type_name] = mySource.[donation_type_name]
     ,myTarget.[active] = mySource.[active]
     ,myTarget.[fund_id] = mySource.[fund_id]
     ,myTarget.[fund_name] = mySource.[fund_name]
     ,myTarget.[qual_for_benefits] = mySource.[qual_for_benefits]
     ,myTarget.[drive_year] = mySource.[drive_year]
     ,myTarget.[fund_desc] = mySource.[fund_desc]
     ,myTarget.[campaign_id] = mySource.[campaign_id]
     ,myTarget.[campaign_name] = mySource.[campaign_name]
     ,myTarget.[gl_code] = mySource.[gl_code]
     ,myTarget.[solicitation_id] = mySource.[solicitation_id]
     ,myTarget.[solicitation_name] = mySource.[solicitation_name]
     ,myTarget.[solicitation_category] = mySource.[solicitation_category]
     ,myTarget.[solicitation_category_name] = mySource.[solicitation_category_name]
     ,myTarget.[contact_type_code] = mySource.[contact_type_code]
     ,myTarget.[contact_type] = mySource.[contact_type]
     ,myTarget.[pledge_used_for_mg] = mySource.[pledge_used_for_mg]
     ,myTarget.[soft_credit_type] = mySource.[soft_credit_type]
     ,myTarget.[soft_credit_name] = mySource.[soft_credit_name]
     ,myTarget.[gift_in_kind_type] = mySource.[gift_in_kind_type]
     ,myTarget.[gift_in_kind_name] = mySource.[gift_in_kind_name]
     ,myTarget.[original_pledge_amount] = mySource.[original_pledge_amount]
     ,myTarget.[pledge_amount] = mySource.[pledge_amount]
     ,myTarget.[donation_paid_amount] = mySource.[donation_paid_amount]
     ,myTarget.[total_received_amount] = mySource.[total_received_amount]
     ,myTarget.[owed_amount] = mySource.[owed_amount]
     ,myTarget.[external_paid_amount] = mySource.[external_paid_amount]
     ,myTarget.[payment_schedule_id] = mySource.[payment_schedule_id]
     ,myTarget.[donor_level_amount_qual] = mySource.[donor_level_amount_qual]
     ,myTarget.[donor_level_amount_not_qual] = mySource.[donor_level_amount_not_qual]
     ,myTarget.[anonymous] = mySource.[anonymous]
     ,myTarget.[source] = mySource.[source]
     ,myTarget.[comments] = mySource.[comments]
     ,myTarget.[cust_donation_info_1] = mySource.[cust_donation_info_1]
     ,myTarget.[cust_donation_info_2] = mySource.[cust_donation_info_2]
     ,myTarget.[cust_donation_info_3] = mySource.[cust_donation_info_3]
     ,myTarget.[cust_donation_info_4] = mySource.[cust_donation_info_4]
     ,myTarget.[cust_donation_info_5] = mySource.[cust_donation_info_5]
     ,myTarget.[cust_donation_info_6] = mySource.[cust_donation_info_6]
     ,myTarget.[cust_donation_info_7] = mySource.[cust_donation_info_7]
     ,myTarget.[cust_donation_info_8] = mySource.[cust_donation_info_8]
     ,myTarget.[cust_donation_info_9] = mySource.[cust_donation_info_9]
     ,myTarget.[cust_donation_info_10] = mySource.[cust_donation_info_10]
     ,myTarget.[cust_donation_info_11] = mySource.[cust_donation_info_11]
     ,myTarget.[cust_donation_info_12] = mySource.[cust_donation_info_12]
     ,myTarget.[cust_donation_info_13] = mySource.[cust_donation_info_13]
     ,myTarget.[cust_donation_info_14] = mySource.[cust_donation_info_14]
     ,myTarget.[cust_donation_info_15] = mySource.[cust_donation_info_15]
     ,myTarget.[cust_donation_info_16] = mySource.[cust_donation_info_16]
     ,myTarget.[cust_donation_info_17] = mySource.[cust_donation_info_17]
     ,myTarget.[cust_donation_info_18] = mySource.[cust_donation_info_18]
     ,myTarget.[cust_donation_info_19] = mySource.[cust_donation_info_19]
     ,myTarget.[cust_donation_info_20] = mySource.[cust_donation_info_20]
     ,myTarget.[patron_listing_name] = mySource.[patron_listing_name]
     ,myTarget.[expected_payment_date] = mySource.[expected_payment_date]
     ,myTarget.[matching_gift_corp_name] = mySource.[matching_gift_corp_name]
     ,myTarget.[matching_gift_comment] = mySource.[matching_gift_comment]
     ,myTarget.[corp_donation_match_used_amount] = mySource.[corp_donation_match_used_amount]
     ,myTarget.[thank_you_letter_id] = mySource.[thank_you_letter_id]
     ,myTarget.[thank_you_letter] = mySource.[thank_you_letter]
     ,myTarget.[thank_you_letter_datetime] = mySource.[thank_you_letter_datetime]
     ,myTarget.[tax_form_sent_datetime] = mySource.[tax_form_sent_datetime]
     ,myTarget.[matched_acct_id] = mySource.[matched_acct_id]
     ,myTarget.[matched_order_num] = mySource.[matched_order_num]
     ,myTarget.[matched_oli] = mySource.[matched_oli]
     ,myTarget.[matched_olis] = mySource.[matched_olis]
     ,myTarget.[renewal_date] = mySource.[renewal_date]
     ,myTarget.[points] = mySource.[points]
     ,myTarget.[orig_cust_donation_id] = mySource.[orig_cust_donation_id]
     ,myTarget.[add_user] = mySource.[add_user]
     ,myTarget.[add_datetime] = mySource.[add_datetime]
     ,myTarget.[upd_user] = mySource.[upd_user]
     ,myTarget.[upd_datetime] = mySource.[upd_datetime]
     ,myTarget.[donation_paid_datetime] = mySource.[donation_paid_datetime]
     ,myTarget.[merchant_code] = mySource.[merchant_code]
     ,myTarget.[ledger_code] = mySource.[ledger_code]
     ,myTarget.[name_type] = mySource.[name_type]
     ,myTarget.[owner_name] = mySource.[owner_name]
     ,myTarget.[owner_name_full] = mySource.[owner_name_full]
     ,myTarget.[pledge_datetime] = mySource.[pledge_datetime]
     ,myTarget.[donation_category] = mySource.[donation_category]
     ,myTarget.[cust_name_id] = mySource.[cust_name_id]
     ,myTarget.[donor_name] = mySource.[donor_name]
     ,myTarget.[donor_name_full] = mySource.[donor_name_full]
     ,myTarget.[stock_symbol] = mySource.[stock_symbol]
     ,myTarget.[stock_num_shares] = mySource.[stock_num_shares]
     ,myTarget.[stock_cert_num] = mySource.[stock_cert_num]
     ,myTarget.[stock_transfer_datetime] = mySource.[stock_transfer_datetime]
     ,myTarget.[stock_transfer_date_low_price] = mySource.[stock_transfer_date_low_price]
     ,myTarget.[stock_transfer_date_high_price] = mySource.[stock_transfer_date_high_price]
     ,myTarget.[stock_transfer_date_avg_price] = mySource.[stock_transfer_date_avg_price]
     ,myTarget.[stock_sales_amt] = mySource.[stock_sales_amt]
     ,myTarget.[stock_broker_fee] = mySource.[stock_broker_fee]
     ,myTarget.[assoc_cust_donation_Id] = mySource.[assoc_cust_donation_Id]
     ,myTarget.[suggested_amount] = mySource.[suggested_amount]
     ,myTarget.[apply_to_email_addr] = mySource.[apply_to_email_addr]
     ,myTarget.[apply_to_acct_id] = mySource.[apply_to_acct_id]
     ,myTarget.[claim_datetime] = mySource.[claim_datetime]
     ,myTarget.[in_memory_of_name] = mySource.[in_memory_of_name]
     ,myTarget.[matching_gift_contact_name] = mySource.[matching_gift_contact_name]
     ,myTarget.[matching_gift_contact_email] = mySource.[matching_gift_contact_email]
     ,myTarget.[matching_gift_contact_phone] = mySource.[matching_gift_contact_phone]
     ,myTarget.[donor_level_amount_qual_apply_to_acct] = mySource.[donor_level_amount_qual_apply_to_acct]
     ,myTarget.[donor_level_amount_not_qual_apply_to_acct] = mySource.[donor_level_amount_not_qual_apply_to_acct]
     ,myTarget.[owner_name_apply_to_acct] = mySource.[owner_name_apply_to_acct]
     ,myTarget.[unclaimed_credits] = mySource.[unclaimed_credits]
     ,myTarget.[apply_to_acct_id_display] = mySource.[apply_to_acct_id_display]
     ,myTarget.[owner_name_apply_to_acct_display] = mySource.[owner_name_apply_to_acct_display]
     ,myTarget.[pledge_expiration_date] = mySource.[pledge_expiration_date]
     ,myTarget.[waive_benefit_ind] = mySource.[waive_benefit_ind]
     ,myTarget.[donor_level_set_id] = mySource.[donor_level_set_id]
     ,myTarget.[donor_level_set_name] = mySource.[donor_level_set_name]
     ,myTarget.[donor_level_calculated_ind] = mySource.[donor_level_calculated_ind]
     ,myTarget.[apply_to_name_First] = mySource.[apply_to_name_First]
     ,myTarget.[apply_to_name_last] = mySource.[apply_to_name_last]
     ,myTarget.[language_name] = mySource.[language_name]
     ,myTarget.[seq_num] = mySource.[seq_num]
     
WHEN NOT MATCHED BY Target
THEN INSERT
     ([InsertDate]
     ,[UpdateDate]
     ,[SourceFileName]
     ,[HashKey]
     ,[cust_donation_id]
     ,[name_last]
     ,[name_last_first_mi]
     ,[company_name]
     ,[acct_id]
     ,[order_num]
     ,[order_line_item]
     ,[order_line_item_seq]
     ,[donation_type]
     ,[donation_type_name]
     ,[active]
     ,[fund_id]
     ,[fund_name]
     ,[qual_for_benefits]
     ,[drive_year]
     ,[fund_desc]
     ,[campaign_id]
     ,[campaign_name]
     ,[gl_code]
     ,[solicitation_id]
     ,[solicitation_name]
     ,[solicitation_category]
     ,[solicitation_category_name]
     ,[contact_type_code]
     ,[contact_type]
     ,[pledge_used_for_mg]
     ,[soft_credit_type]
     ,[soft_credit_name]
     ,[gift_in_kind_type]
     ,[gift_in_kind_name]
     ,[original_pledge_amount]
     ,[pledge_amount]
     ,[donation_paid_amount]
     ,[total_received_amount]
     ,[owed_amount]
     ,[external_paid_amount]
     ,[payment_schedule_id]
     ,[donor_level_amount_qual]
     ,[donor_level_amount_not_qual]
     ,[anonymous]
     ,[source]
     ,[comments]
     ,[cust_donation_info_1]
     ,[cust_donation_info_2]
     ,[cust_donation_info_3]
     ,[cust_donation_info_4]
     ,[cust_donation_info_5]
     ,[cust_donation_info_6]
     ,[cust_donation_info_7]
     ,[cust_donation_info_8]
     ,[cust_donation_info_9]
     ,[cust_donation_info_10]
     ,[cust_donation_info_11]
     ,[cust_donation_info_12]
     ,[cust_donation_info_13]
     ,[cust_donation_info_14]
     ,[cust_donation_info_15]
     ,[cust_donation_info_16]
     ,[cust_donation_info_17]
     ,[cust_donation_info_18]
     ,[cust_donation_info_19]
     ,[cust_donation_info_20]
     ,[patron_listing_name]
     ,[expected_payment_date]
     ,[matching_gift_corp_name]
     ,[matching_gift_comment]
     ,[corp_donation_match_used_amount]
     ,[thank_you_letter_id]
     ,[thank_you_letter]
     ,[thank_you_letter_datetime]
     ,[tax_form_sent_datetime]
     ,[matched_acct_id]
     ,[matched_order_num]
     ,[matched_oli]
     ,[matched_olis]
     ,[renewal_date]
     ,[points]
     ,[orig_cust_donation_id]
     ,[add_user]
     ,[add_datetime]
     ,[upd_user]
     ,[upd_datetime]
     ,[donation_paid_datetime]
     ,[merchant_code]
     ,[ledger_code]
     ,[name_type]
     ,[owner_name]
     ,[owner_name_full]
     ,[pledge_datetime]
     ,[donation_category]
     ,[cust_name_id]
     ,[donor_name]
     ,[donor_name_full]
     ,[stock_symbol]
     ,[stock_num_shares]
     ,[stock_cert_num]
     ,[stock_transfer_datetime]
     ,[stock_transfer_date_low_price]
     ,[stock_transfer_date_high_price]
     ,[stock_transfer_date_avg_price]
     ,[stock_sales_amt]
     ,[stock_broker_fee]
     ,[assoc_cust_donation_Id]
     ,[suggested_amount]
     ,[apply_to_email_addr]
     ,[apply_to_acct_id]
     ,[claim_datetime]
     ,[in_memory_of_name]
     ,[matching_gift_contact_name]
     ,[matching_gift_contact_email]
     ,[matching_gift_contact_phone]
     ,[donor_level_amount_qual_apply_to_acct]
     ,[donor_level_amount_not_qual_apply_to_acct]
     ,[owner_name_apply_to_acct]
     ,[unclaimed_credits]
     ,[apply_to_acct_id_display]
     ,[owner_name_apply_to_acct_display]
     ,[pledge_expiration_date]
     ,[waive_benefit_ind]
     ,[donor_level_set_id]
     ,[donor_level_set_name]
     ,[donor_level_calculated_ind]
     ,[apply_to_name_First]
     ,[apply_to_name_last]
     ,[language_name]
     ,[seq_num]
     )
VALUES
     (@RunTime --InsertDate
     ,@RunTime --UpdateDate
     ,mySource.[SourceFileName]
     ,mySource.[ETL_DeltaHashKey]
     ,mySource.[cust_donation_id]
     ,mySource.[name_last]
     ,mySource.[name_last_first_mi]
     ,mySource.[company_name]
     ,mySource.[acct_id]
     ,mySource.[order_num]
     ,mySource.[order_line_item]
     ,mySource.[order_line_item_seq]
     ,mySource.[donation_type]
     ,mySource.[donation_type_name]
     ,mySource.[active]
     ,mySource.[fund_id]
     ,mySource.[fund_name]
     ,mySource.[qual_for_benefits]
     ,mySource.[drive_year]
     ,mySource.[fund_desc]
     ,mySource.[campaign_id]
     ,mySource.[campaign_name]
     ,mySource.[gl_code]
     ,mySource.[solicitation_id]
     ,mySource.[solicitation_name]
     ,mySource.[solicitation_category]
     ,mySource.[solicitation_category_name]
     ,mySource.[contact_type_code]
     ,mySource.[contact_type]
     ,mySource.[pledge_used_for_mg]
     ,mySource.[soft_credit_type]
     ,mySource.[soft_credit_name]
     ,mySource.[gift_in_kind_type]
     ,mySource.[gift_in_kind_name]
     ,mySource.[original_pledge_amount]
     ,mySource.[pledge_amount]
     ,mySource.[donation_paid_amount]
     ,mySource.[total_received_amount]
     ,mySource.[owed_amount]
     ,mySource.[external_paid_amount]
     ,mySource.[payment_schedule_id]
     ,mySource.[donor_level_amount_qual]
     ,mySource.[donor_level_amount_not_qual]
     ,mySource.[anonymous]
     ,mySource.[source]
     ,mySource.[comments]
     ,mySource.[cust_donation_info_1]
     ,mySource.[cust_donation_info_2]
     ,mySource.[cust_donation_info_3]
     ,mySource.[cust_donation_info_4]
     ,mySource.[cust_donation_info_5]
     ,mySource.[cust_donation_info_6]
     ,mySource.[cust_donation_info_7]
     ,mySource.[cust_donation_info_8]
     ,mySource.[cust_donation_info_9]
     ,mySource.[cust_donation_info_10]
     ,mySource.[cust_donation_info_11]
     ,mySource.[cust_donation_info_12]
     ,mySource.[cust_donation_info_13]
     ,mySource.[cust_donation_info_14]
     ,mySource.[cust_donation_info_15]
     ,mySource.[cust_donation_info_16]
     ,mySource.[cust_donation_info_17]
     ,mySource.[cust_donation_info_18]
     ,mySource.[cust_donation_info_19]
     ,mySource.[cust_donation_info_20]
     ,mySource.[patron_listing_name]
     ,mySource.[expected_payment_date]
     ,mySource.[matching_gift_corp_name]
     ,mySource.[matching_gift_comment]
     ,mySource.[corp_donation_match_used_amount]
     ,mySource.[thank_you_letter_id]
     ,mySource.[thank_you_letter]
     ,mySource.[thank_you_letter_datetime]
     ,mySource.[tax_form_sent_datetime]
     ,mySource.[matched_acct_id]
     ,mySource.[matched_order_num]
     ,mySource.[matched_oli]
     ,mySource.[matched_olis]
     ,mySource.[renewal_date]
     ,mySource.[points]
     ,mySource.[orig_cust_donation_id]
     ,mySource.[add_user]
     ,mySource.[add_datetime]
     ,mySource.[upd_user]
     ,mySource.[upd_datetime]
     ,mySource.[donation_paid_datetime]
     ,mySource.[merchant_code]
     ,mySource.[ledger_code]
     ,mySource.[name_type]
     ,mySource.[owner_name]
     ,mySource.[owner_name_full]
     ,mySource.[pledge_datetime]
     ,mySource.[donation_category]
     ,mySource.[cust_name_id]
     ,mySource.[donor_name]
     ,mySource.[donor_name_full]
     ,mySource.[stock_symbol]
     ,mySource.[stock_num_shares]
     ,mySource.[stock_cert_num]
     ,mySource.[stock_transfer_datetime]
     ,mySource.[stock_transfer_date_low_price]
     ,mySource.[stock_transfer_date_high_price]
     ,mySource.[stock_transfer_date_avg_price]
     ,mySource.[stock_sales_amt]
     ,mySource.[stock_broker_fee]
     ,mySource.[assoc_cust_donation_Id]
     ,mySource.[suggested_amount]
     ,mySource.[apply_to_email_addr]
     ,mySource.[apply_to_acct_id]
     ,mySource.[claim_datetime]
     ,mySource.[in_memory_of_name]
     ,mySource.[matching_gift_contact_name]
     ,mySource.[matching_gift_contact_email]
     ,mySource.[matching_gift_contact_phone]
     ,mySource.[donor_level_amount_qual_apply_to_acct]
     ,mySource.[donor_level_amount_not_qual_apply_to_acct]
     ,mySource.[owner_name_apply_to_acct]
     ,mySource.[unclaimed_credits]
     ,mySource.[apply_to_acct_id_display]
     ,mySource.[owner_name_apply_to_acct_display]
     ,mySource.[pledge_expiration_date]
     ,mySource.[waive_benefit_ind]
     ,mySource.[donor_level_set_id]
     ,mySource.[donor_level_set_name]
     ,mySource.[donor_level_calculated_ind]
     ,mySource.[apply_to_name_First]
     ,mySource.[apply_to_name_last]
     ,mySource.[language_name]
     ,mySource.[seq_num]
     )
;

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Complete', @ExecutionId



END TRY 
BEGIN CATCH 

	DECLARE @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
	DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
	DECLARE @ErrorState INT = ERROR_STATE();
			
	PRINT @ErrorMessage
	EXEC etl.LogEventRecordDB @Batchid, 'Error', @ProcedureName, 'Merge Load', 'Merge Error', @ErrorMessage, @ExecutionId
	EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Complete', @ExecutionId

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

END CATCH

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Complete', @ExecutionId


END

GO
