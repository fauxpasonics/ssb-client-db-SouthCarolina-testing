SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [ods].[LoadCustTrace]
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
Date:     12/16/2015
Comments: Initial creation
*************************************************************************************/

DECLARE @RunTime DATETIME = GETDATE()

DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @ProcedureName nvarchar(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.TM_CustTrace),'0');	
DECLARE @SrcDataSize NVARCHAR(255) = '0'

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Start', @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Row Count', @SrcRowCount, @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src DataSize', @SrcDataSize, @ExecutionId

SELECT CAST(NULL AS BINARY(32)) HashKey, seq_id, acct_id, full_name, activity_name, call_reason, call_reason_name, rc, error_desc, ip_address, add_user, add_datetime, cust_name_id, activity_comment, SourceFileName
INTO #SrcData
FROM src.TM_CustTrace

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET HashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(acct_id),'DBNULL_TEXT') + ISNULL(RTRIM(activity_comment),'DBNULL_TEXT') + ISNULL(RTRIM(activity_name),'DBNULL_TEXT') + ISNULL(RTRIM(add_datetime),'DBNULL_TEXT') + ISNULL(RTRIM(add_user),'DBNULL_TEXT') + ISNULL(RTRIM(call_reason),'DBNULL_TEXT') + ISNULL(RTRIM(call_reason_name),'DBNULL_TEXT') + ISNULL(RTRIM(cust_name_id),'DBNULL_TEXT') + ISNULL(RTRIM(error_desc),'DBNULL_TEXT') + ISNULL(RTRIM(full_name),'DBNULL_TEXT') + ISNULL(RTRIM(ip_address),'DBNULL_TEXT') + ISNULL(RTRIM(rc),'DBNULL_TEXT') + ISNULL(RTRIM(seq_id),'DBNULL_TEXT') + ISNULL(RTRIM(SourceFileName),'DBNULL_TEXT'))

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'ETL_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (seq_id)
CREATE NONCLUSTERED INDEX IDX_HashKey ON #SrcData (HashKey)

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId

MERGE ods.TM_CustTrace AS myTarget

USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON myTarget.seq_id = mySource.seq_id

WHEN MATCHED AND (
     ISNULL(mySource.HashKey,-1) <> ISNULL(myTarget.HashKey, -1)
	 
)
THEN UPDATE SET
      myTarget.[seq_id] = mySource.[seq_id]
     ,myTarget.[acct_id] = mySource.[acct_id]
     ,myTarget.[full_name] = mySource.[full_name]
     ,myTarget.[activity_name] = mySource.[activity_name]
     ,myTarget.[call_reason] = mySource.[call_reason]
     ,myTarget.[call_reason_name] = mySource.[call_reason_name]
     ,myTarget.[rc] = mySource.[rc]
     ,myTarget.[error_desc] = mySource.[error_desc]
     ,myTarget.[ip_address] = mySource.[ip_address]
     ,myTarget.[add_user] = mySource.[add_user]
     ,myTarget.[add_datetime] = mySource.[add_datetime]
     ,myTarget.[cust_name_id] = mySource.[cust_name_id]
     ,myTarget.[activity_comment] = mySource.[activity_comment]     
     ,myTarget.[UpdateDate] = @RunTime
     ,myTarget.[SourceFileName] = mySource.[SourceFileName]
     ,myTarget.[HashKey] = mySource.HashKey
     
WHEN NOT MATCHED BY Target
THEN INSERT
     ([seq_id]
     ,[acct_id]
     ,[full_name]
     ,[activity_name]
     ,[call_reason]
     ,[call_reason_name]
     ,[rc]
     ,[error_desc]
     ,[ip_address]
     ,[add_user]
     ,[add_datetime]
     ,[cust_name_id]
     ,[activity_comment]
     ,[InsertDate]
     ,[UpdateDate]
     ,[SourceFileName]
     ,[HashKey]
     )
VALUES
     (
     mySource.[seq_id]
     ,mySource.[acct_id]
     ,mySource.[full_name]
     ,mySource.[activity_name]
     ,mySource.[call_reason]
     ,mySource.[call_reason_name]
     ,mySource.[rc]
     ,mySource.[error_desc]
     ,mySource.[ip_address]
     ,mySource.[add_user]
     ,mySource.[add_datetime]
     ,mySource.[cust_name_id]
     ,mySource.[activity_comment]
	 ,@RunTime --ETL_CreatedDate
     ,@RunTime --ETL_UpdateddDate
     ,mySource.[SourceFileName]
     ,mySource.HashKey

     )
;



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
