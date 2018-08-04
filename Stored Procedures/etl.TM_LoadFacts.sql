SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [etl].[TM_LoadFacts]
AS
BEGIN

	--SELECT GETDATE()

	DECLARE @BatchId INT = 0;
	DECLARE @ExecutionId uniqueidentifier = newid();
	DECLARE @ProcedureName nvarchar(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
	DECLARE @LogEventDefault NVARCHAR(255) = 'Processing Status'

	EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Fact Load', @LogEventDefault, 'Start', @ExecutionId

	DECLARE @LoadDate DATETIME = DATEADD(DAY, -1, GETDATE())

	EXEC etl.FactTicketSales_DeleteReturns

	EXEC [etl].[TM_LoadFactTicketSales] 0, @LoadDate
	EXEC etl.TM_LoadFactTicketSales_wPaymentDate --Update DimDateID to reflect MinPaymentDate

	--EXEC etl.TM_Ticket_Pacing
		
	EXEC [etl].[Load_FactInventory]

	EXEC [etl].[FactAttendance_UpdateAttendance]
	EXEC [etl].[FactAttendance_UpdateAttendanceAPI]
	EXEC [etl].[FactInventory_UpdateResoldSeats]

	/*EXEC [etl].[TM_ProcessMergedAccountTransactions]*/


	EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Fact Load', @LogEventDefault, 'Complete', @ExecutionId

	EXEC etl.Load_ReportTables

END




GO
