SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[TM_ProcessMergedAccountTransactions]

as
BEGIN

insert into etl.TM_AccountMergeLog (NoteId, TM_MergedDate, MergedAcctId, MergedIntoAcctId, ETL_MergedDate)

select vl.NoteId, vl.TM_MergedDate, vl.MergedAcctId, vl.MergedIntoAcctId, null
from ods.TM_vw_MergedAccountLog vl
left outer join etl.TM_AccountMergeLog l on vl.NoteId = l.NoteId
where l.NoteId is null
order by vl.noteid

DECLARE @MergeLogId int, @MergedAcctId bigint, @MergedIntoAcctId BIGINT, @DimCustomerIdNew BIGINT

DECLARE CURSOR_MergeQueue CURSOR FOR 
SELECT MergeLogId, MergedAcctId, MergedIntoAcctId
FROM etl.TM_AccountMergeLog
WHERE ETL_MergedDate is null
ORDER BY NoteId;

OPEN CURSOR_MergeQueue

FETCH NEXT FROM CURSOR_MergeQueue 
INTO @MergeLogId, @MergedAcctId, @MergedIntoAcctId

WHILE @@FETCH_STATUS = 0
BEGIN
	
	print 'Merging Account ' + convert(varchar(25), @MergedAcctId) + ' into ' + convert(varchar(25), @MergedIntoAcctId)

	update ods.TM_Tkt
	set acct_id = @MergedIntoAcctId
	, UpdateDate = getdate()
	where acct_id = @MergedAcctId

	update ods.TM_Plans
	set acct_id = @MergedIntoAcctId
	, UpdateDate = getdate()
	where acct_id = @MergedAcctId

	update ods.TM_Cust
	set rec_status = 'Merged'
	where acct_id = @MergedAcctId

	UPDATE dbo.DimCustomer
	set CustomerStatus = 'Merged'
	where SourceSystem = 'TM'
	AND ExtAttribute11 = @MergedAcctId

	SELECT @DimCustomerIdNew = dc.DimCustomerId
	FROM dbo.DimCustomer dc
	WHERE SourceSystem = 'TM' AND CustomerType = 'Primary' AND AccountId = @MergedIntoAcctId
	

	UPDATE fts
	SET fts.DimCustomerId = @DimCustomerIdNew
	FROM dbo.FactTicketSales fts
	INNER JOIN (
		SELECT DimCustomerId
		FROM dbo.DimCustomer
		WHERE SourceSystem = 'TM' AND AccountId = @MergedAcctId
	) c ON fts.DimCustomerId = c.DimCustomerId


	UPDATE fts
	SET fts.DimCustomerId = @DimCustomerIdNew
	, fts.SSID_acct_id = @MergedIntoAcctId
	FROM dbo.FactTicketSalesPacing fts
	INNER JOIN (
		SELECT DimCustomerId
		FROM dbo.DimCustomer
		WHERE SourceSystem = 'TM' AND AccountId = @MergedAcctId
	) c ON fts.DimCustomerId = c.DimCustomerId


	update etl.TM_AccountMergeLog
	set ETL_MergedDate = GETDATE()
	where MergeLogId = @MergeLogId

    FETCH NEXT FROM CURSOR_MergeQueue 
    INTO @MergeLogId, @MergedAcctId, @MergedIntoAcctId
END 

CLOSE CURSOR_MergeQueue;
DEALLOCATE CURSOR_MergeQueue;


END

GO
