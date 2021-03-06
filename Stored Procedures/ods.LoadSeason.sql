SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [ods].[LoadSeason]
(
	@BatchId bigint = 0,
	@Options nvarchar(MAX) = null
)
as
BEGIN
SET NOCOUNT ON;
	/*
	Log Level value optionally specified in the @Options parameter, if not provided set to 3
	Log Level 1 = Error Logging, 2 = Error + Warnings, 3 = Error + Warnings + Info, 0 = None(use for dev only)

	Optionally can disable merge crud options with true value for (DisableInsert, DisableUpdate, DisableDelete)
	*/
	
	DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.TM_Season),'0');	

	/*Set ExecutionId to new guid to group log records together*/
	DECLARE @ExecutionId uniqueidentifier = newid();
	DECLARE @ProcedureName nvarchar(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);

	/*Load Options into a temp table*/
	SELECT Col1 AS OptionKey, Col2 as OptionValue INTO #Options FROM [dbo].[SplitMultiColumn](@Options, '=', ';')

	/*Extract Options, default values set if the option is not specified*/
	DECLARE @LogLevel int = ISNULL((SELECT TRY_PARSE(OptionValue as int) FROM #Options WHERE OptionKey = 'LogLevel'),3)
	DECLARE @DisableInsert nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableInsert'),'false')
	DECLARE @DisableUpdate nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableUpdate'),'false')
	DECLARE @DisableDelete nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableDelete'),'false')


	if (@LogLevel >= 3)
	begin 
		EXEC etl.LogEventRecord @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Start', 'Starting Merge Load', @ExecutionId
		EXEC etl.LogEventRecord @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Row Count', @SrcRowCount, @ExecutionId
	END	

	/*Put all merge logic inside of try block*/
	BEGIN TRY

	DECLARE @RunTime datetime = GETDATE();

MERGE ods.TM_Season AS target
USING 
(
    SELECT [season_id]
        ,[name]
      ,[line1]
      ,[line2]
      ,[line3]
      ,[arena_id]
      ,[manifest_id]
      ,[add_datetime]
      ,[upd_user]
      ,[upd_datetime]
      ,[season_year]
      ,[org_id]
	  ,[SourceFileName]
      ,[SrcHashKey]
  FROM [src].[vw_TM_Season]
  WHERE MergeRank = 1
) as Source
     ON source.[season_id] = Target.[season_id]
WHEN MATCHED AND source.SrcHashKey <> target.HashKey
THEN UPDATE SET 
    [name] = Source.[name],
    [line1] = Source.[line1],
    [line2] = Source.[line2],
    [line3] = Source.[line3],
    [arena_id] = Source.[arena_id],
    [manifest_id] = Source.[manifest_id],
    [add_datetime] = Source.[add_datetime],
    [upd_user] = Source.[upd_user],
    [upd_datetime] = Source.[upd_datetime],
    [season_year] = Source.[season_year],
    [org_id] =Source.[org_id],
	[SourceFileName]			= source.[SourceFileName],
	[UpdateDate]				= @RunTime,	 
    [HashKey] = Source.[SrcHashKey]
WHEN NOT MATCHED BY Target THEN
INSERT
    (
        [season_id], 
        [name], 
        [line1], 
        [line2], 
        [line3], 
        [arena_id], 
        [manifest_id], 
        [add_datetime], 
        [upd_user], 
        [upd_datetime], 
        [season_year], 
        [org_id], 
		[SourceFileName],
	  [InsertDate],
	  [UpdateDate],	 
        [HashKey]
        
    )
    VALUES (
        source.[season_id], 
        source.[name], 
        source.[line1], 
        source.[line2], 
        source.[line3], 
        source.[arena_id], 
        source.[manifest_id], 
        source.[add_datetime], 
        source.[upd_user], 
        source.[upd_datetime], 
        source.[season_year], 
        source.[org_id], 
		source.[SourceFileName],
	  @RunTime,
	  @RunTime,
        source.[SrcHashKey]
    );

	END TRY

	BEGIN CATCH 
		/*Log Error*/
		if (@LogLevel >= 1)
		begin 
			DECLARE @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
			DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
			DECLARE @ErrorState INT = ERROR_STATE();
			
			if (@LogLevel >= 1)
			begin
				EXEC etl.LogEventRecord @Batchid, 'Error', @ProcedureName, 'Merge Load', 'Merge Error', @ErrorMessage, @ExecutionId
			end 
			if (@LogLevel >= 3)
			begin 
				EXEC etl.LogEventRecord @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Complete', 'Completed Merge Load', @ExecutionId
			END

			RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

		END
	END CATCH

	if (@LogLevel >= 3)
	begin 
		EXEC etl.LogEventRecord @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Complete', 'Completed Merge Load', @ExecutionId
	END

END












GO
