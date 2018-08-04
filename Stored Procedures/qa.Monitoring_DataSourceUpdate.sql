SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [qa].[Monitoring_DataSourceUpdate]
AS
BEGIN

SET XACT_ABORT ON;
SET NOCOUNT ON;
BEGIN TRY
    BEGIN TRANSACTION;
    -- SQL statement goes here

		--For Logging 
		DECLARE @RunTime DATETIME = GETDATE()
		DECLARE @ExecutionId uniqueidentifier = newid();
		DECLARE @ProcedureName nvarchar(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);

		IF OBJECT_ID('tempdb..#SQLStmts','U') IS NOT NULL DROP TABLE #SQLStmts

		SELECT 'INSERT INTO #Results SELECT ' + TRY_CAST(MonitoringDataSourceId AS VARCHAR(256)) + ' AS MonitoringDataSourceId, ''' + DataSourceName +''' AS [DataSourceName], '+ColumnOperator+'(['+ColumnName+']) AS [SourceUpdatedDate], ' + 
		'CASE WHEN '+ColumnOperator+'(['+ColumnName+']) > DATEADD(hh, -' + TimeDelayHours + N', GETDATE()) THEN ''Nominal'' ELSE ''Error'' END AS [Status] FROM ' + TableName + ' WITH (NOLOCK) ' + CASE WHEN FilterClause IS NOT NULL THEN FilterClause ELSE '' END 'SQLStmt'
		INTO #SQLStmts 
		FROM [qa].[MonitoringDataSource]
		WHERE IsActive = 1

		DECLARE @SQL NVARCHAR(MAX) = NULL;

		IF OBJECT_ID('tempdb..#Results','U') IS NOT NULL 
			DROP TABLE #Results
		CREATE TABLE #Results (
			MonitoringDataSourceId INT,
			DataSourceName NVARCHAR(255), 
			SourceUpdatedDate DATETIME NULL, 
			Status NVARCHAR(50) 
		) 

		WHILE (SELECT COUNT(1) FROM #SQLStmts) > 0
		BEGIN 

			SELECT @SQL = SQLStmt
			FROM #SQLStmts

			--PRINT @SQL 
			EXEC(@SQL) 

			DELETE #SQLStmts
			WHERE SQLStmt = @SQL

		END 

		IF NOT EXISTS (SELECT 1 FROM #Results) 
		BEGIN 

			INSERT INTO qa.MonitoringDataSourceAudit
			(
				MonitoringDataSourceId,
				DataSourceName,
				SourceUpdatedDate,
				Status,
				CreatedDate
			)
			VALUES
			(   
				-1,
				N'Error',       -- DataSourceName - nvarchar(255)
				GETDATE(), -- SourceUpdatedDate - datetime
				N'ERROR - No Data',       -- Status - nvarchar(255)
				GETDATE()  -- CreatedDate - datetime
				)

			--SELECT NULL [DataSourceName], NULL [SourceUpdatedDate], 'ERROR' [Status]

		END 
		ELSE 
		BEGIN 

			INSERT INTO qa.MonitoringDataSourceAudit
			(
				MonitoringDataSourceId,
				DataSourceName,
				SourceUpdatedDate,
				Status,
				CreatedDate
			)
			SELECT 
				MonitoringDataSourceId,
				DataSourceName, 
				SourceUpdatedDate, 
				Status, 
				GETUTCDATE() 
			FROM #Results 
			ORDER BY DataSourceName

			--SELECT * FROM #Results ORDER BY SourceUpdatedDate

		END 

	-- If statement succeeds, commit the transaction.	
	COMMIT TRANSACTION;

END TRY
BEGIN CATCH
	DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
	DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
	DECLARE @ErrorState INT = ERROR_STATE();

	--Using THROW below as opposed to RAISERROR per MS Link
	--https://docs.microsoft.com/en-us/sql/t-sql/language-elements/raiserror-transact-sql?view=sql-server-2017
	--RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)						

    -- Test XACT_STATE for 0, 1, or -1.
    -- If 1, the transaction is committable.
    -- If -1, the transaction is uncommittable and should be rolled back.
    -- If 0 means there is no transaction and a commit or rollback operation would generate an error.

    -- Test whether the transaction is uncommittable.
    IF (XACT_STATE()) = -1
    BEGIN
        ROLLBACK TRANSACTION;
    END;

    -- Test whether the transaction is active and valid.
    IF (XACT_STATE()) = 1
    BEGIN
        COMMIT TRANSACTION;   
    END;
    
	-- THROW ERROR
	THROW;

END CATCH;
END
GO
