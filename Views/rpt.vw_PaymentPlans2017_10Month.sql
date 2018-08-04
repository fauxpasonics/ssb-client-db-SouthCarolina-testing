SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [rpt].[vw_PaymentPlans2017_10Month]
AS

SELECT acct_id
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
FROM ods.TM_PaySchedule
WHERE inet_plan_name IN ('2017 10 MONTH', '2017IMG 10 Month')






GO
