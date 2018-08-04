SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** 

DCH 2018-07-16	-	need to explicitly cast EmailPrimary as nvarchar(255) due to changes in dbo.vwDimCustomer_ModAcctID

******/

CREATE PROCEDURE [rpt].[PaymentPlans2017_HasWB]
AS


SELECT acct_id
	, b.FirstName
	, b.LastName
	, CAST(b.EmailPrimary as nvarchar(256)) as EmailPrimary
	, payment_schedule_id
	, invoice_id
	, payment_plan_id
	, comments
	, add_user
	, add_datetime
	, payment_plan_name
	, [periods]
	, last_period_paid
	, purchase_amount
	, paid_amount
	, percent_due
	, percent_paid
	, compliant
	, invoice_desc
	, effective_Date
	, expiration_date
	, inet_effective_Date
	, inet_expiration_Date
	, inet_plan_name
	, payment_plan_type
	, last_payment_number
	, period_type
	, [start_date]
FROM ods.TM_PaySchedule a
JOIN dbo.vwDimCustomer_ModAcctId b ON CAST(a.acct_id AS NVARCHAR(100)) = b.AccountId AND b.SourceSystem = 'TM' AND b.CustomerType = 'Primary'
WHERE inet_plan_name IN ('2017 10 MONTH', '2017IMG 10 Month')
AND acct_id IN (
	SELECT DISTINCT acct_id
	FROM ods.TM_vw_Ticket
	WHERE event_name IN ('WB18','WB18DEP')
	)
AND a.acct_id NOT IN (
	SELECT DISTINCT acct_id
	FROM ods.TM_vw_Ticket
	WHERE event_name IN ('BB18','BB18DEP')
	)

GO
