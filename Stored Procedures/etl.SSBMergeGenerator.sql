SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [etl].[SSBMergeGenerator]
     @Target VARCHAR(256),
     @Source VARCHAR(256),
     @Target_Key VARCHAR(256),
     @Source_Key VARCHAR(256),
     @Proc_Name VARCHAR(256)
AS
/**************************************Comments***************************************
**************************************************************************************
Mod #:  1
Name:     ssbcloud\dschaller
Date:     01/19/2015
Comments: This sproc creates merge logic dynamically based on values passed into sproc.

Mod #:		2
Name:		ssbcloud\dhorstman
Date:		12/31/2015
Comments:	Added 2 more VARCHAR(MAX) variables to handle extremely wide tables that overran
			the limitations of one variable.
*************************************************************************************/
--Variables that will need to be passed into the sproc
--DECLARE
--     @Target VARCHAR(256),
--     @Source VARCHAR(256),
--     @Target_Key VARCHAR(256),
--     @Source_Key VARCHAR(256),
--     @Proc_Name VARCHAR(256)

--SET @Target = 'ods.TI_PatronMDM_Athletics'
--SET @Source = 'etl.vw_src_TI_PatronMDM_Athletics'
--SET @Target_Key = 'Patron'
--SET @Source_Key = 'Patron'
--SET @Proc_Name = 'ETL.ods_Load_TI_PatronMDM_Athletics'

--Variables that will stay in sproc contents
DECLARE
     @SQL VARCHAR(MAX),
	 @SQL2 VARCHAR(MAX),
	 @SQL3 VARCHAR(MAX)

DECLARE
	 @ColString VARCHAR(MAX)
SET
	 @ColString = 
	 ( SELECT STUFF ((
                    SELECT ', ' + name 
                    FROM sys.columns
                    WHERE object_id = OBJECT_ID(@Source) AND name NOT IN ('ETL_ID', 'ETL_CreatedDate')		
					ORDER BY column_id		
                    FOR XML PATH('')), 1, 1, '') 
	 )

DECLARE
	 @HashSyntax VARCHAR(MAX)

DECLARE	 @HashTbl TABLE (HashSyntax VARCHAR(MAX))
INSERT @HashTbl (HashSyntax)
EXEC  [dbo].[SSBHashFieldSyntaxDS] @Source, 'ETL_ID, ETL_CreatedDate'

SET @HashSyntax = (SELECT TOP 1 HashSyntax FROM @HashTbl)

DECLARE
	 @JoinString VARCHAR(MAX)
SET @JoinString = 
	(
		SELECT STUFF ((
        SELECT ' and ' + match  
        FROM
		(
			SELECT a.id, 'myTarget.' + a.Item + ' = mySource.' + b.Item AS match
			FROM dbo.Split_DS (@Target_Key, ',') a INNER JOIN
			dbo.Split_DS (@Source_Key, ',') b ON a.ID = b.ID
		)	x	
		ORDER BY id		
        FOR XML PATH('')), 1, 5, '')
	)

	DECLARE @SqlStringMax AS VARCHAR(MAX) = ''
	DECLARE @SchemaName  AS VARCHAR(255) = [dbo].[fnGetValueFromDelimitedString](@Source, '.' ,1)
	DECLARE @Table AS VARCHAR(255) = [dbo].[fnGetValueFromDelimitedString](@Source, '.' ,2)

	
	SELECT @SqlStringMax = @sqlStringMax + 'OR ISNULL(mySource.' + COLUMN_NAME + ','''') <> ' + 'ISNULL(myTarget.' + COLUMN_NAME + ','''') '
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_SCHEMA = @SchemaName AND TABLE_NAME = @Table
	AND ISNULL(CHARACTER_MAXIMUM_LENGTH, 0) < 0
	AND COLUMN_NAME NOT IN ('ETL_ID', 'ETL_CreatedDate')

	
SELECT @SQL = 
'CREATE PROCEDURE ' + @Proc_Name + CHAR(10) + 
'(
	@BatchId INT = 0,
	@Options NVARCHAR(MAX) = null
)
AS 

BEGIN
/**************************************Comments***************************************
**************************************************************************************
Mod #:  1
Name:     ' + CURRENT_USER + '
Date:     ' + CONVERT(VARCHAR, GETDATE(), 101) + '
Comments: Initial creation
*************************************************************************************/

DECLARE @RunTime DATETIME = GETDATE()

DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @ProcedureName nvarchar(255) = OBJECT_SCHEMA_NAME(@@PROCID) + ''.'' + OBJECT_NAME(@@PROCID);
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ' + @Source + '),''0'');	
DECLARE @SrcDataSize NVARCHAR(255) = ''0''

/*Load Options into a temp table*/
SELECT Col1 AS OptionKey, Col2 as OptionValue INTO #Options FROM [dbo].[SplitMultiColumn](@Options, ''='', '';'')

/*Extract Options, default values set if the option is not specified*/	
DECLARE @DisableInsert nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = ''DisableInsert''),''false'')
DECLARE @DisableUpdate nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = ''DisableUpdate''),''false'')
DECLARE @DisableDelete nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = ''DisableDelete''),''true'')


BEGIN TRY 

PRINT ''Execution Id: '' + CONVERT(NVARCHAR(100),@ExecutionId)

EXEC etl.LogEventRecordDB @Batchid, ''Info'', @ProcedureName, ''Merge Load'', ''Procedure Processing'', ''Start'', @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, ''Info'', @ProcedureName, ''Merge Load'', ''Src Row Count'', @SrcRowCount, @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, ''Info'', @ProcedureName, ''Merge Load'', ''Src DataSize'', @SrcDataSize, @ExecutionId

SELECT CAST(NULL AS BINARY(32)) ETL_DeltaHashKey
, ' + @ColString + '
INTO #SrcData
FROM (
	SELECT ' + @ColString + '
	, ROW_NUMBER() OVER(PARTITION BY ' + @Source_Key + ' ORDER BY ETL_ID) RowRank
	FROM ' + @Source + '
) a
WHERE RowRank = 1

EXEC etl.LogEventRecordDB @Batchid, ''Info'', @ProcedureName, ''Merge Load'', ''Src Table Setup'', ''Temp Table Loaded'', @ExecutionId

UPDATE #SrcData
SET ETL_DeltaHashKey = ' + @HashSyntax + '

EXEC etl.LogEventRecordDB @Batchid, ''Info'', @ProcedureName, ''Merge Load'', ''Src Table Setup'', ''ETL_DeltaHashKey Set'', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (' + @Source_Key + ')
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)

EXEC etl.LogEventRecordDB @Batchid, ''Info'', @ProcedureName, ''Merge Load'', ''Src Table Setup'', ''Temp Table Indexes Created'', @ExecutionId

EXEC etl.LogEventRecordDB @Batchid, ''Info'', @ProcedureName, ''Merge Load'', ''Merge Statement Execution'', ''Start'', @ExecutionId
';



SELECT @SQL2 = 
'MERGE ' + @Target + ' AS myTarget
USING #SrcData AS mySource
ON ' + @JoinString + '

WHEN MATCHED AND (
     ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
	 ' + @SqlStringMax + '
)
THEN UPDATE SET
      ' +
          STUFF ((
                    SELECT CASE 
								WHEN name = 'ETL_UpdatedDate' THEN ', myTarget.[' + name + '] = @RunTime' + CHAR(10) + '     '
								WHEN name = 'ETL_IsDeleted' THEN ', myTarget.[ETL_IsDeleted] = 0' + CHAR(10) + '     '
								WHEN name = 'ETL_DeletedDate' THEN ', myTarget.[ETL_DeletedDate] = NULL' + CHAR(10) + '     '
                                ELSE ', myTarget.[' + name + '] = mySource.[' + name + ']' + CHAR(10) + '     '
                           END
						FROM sys.columns
						WHERE object_id = OBJECT_ID(@Target)
                         AND (name NOT LIKE 'ETL[_]%'
                              OR name IN ( 'ETL_DeltaHashKey', 'ETL_UpdatedDate', 'ETL_IsDeleted', 'ETL_DeletedDate', 'ETL_SourceFileName' )
						)
						ORDER BY column_id
                    FOR XML PATH('')), 1, 1, '')  +
'

';



SELECT @SQL3 = 
'WHEN NOT MATCHED BY Target
THEN INSERT
     (' + 
          STUFF ((
                    SELECT ',[' + name + ']' + CHAR(10) + '     '
						FROM sys.columns
						WHERE object_id = OBJECT_ID(@Target)
                         AND name <> 'ETL_ID'
					ORDER BY column_id
                    FOR XML PATH('')), 1, 1, '') + ')
VALUES
     (@RunTime --ETL_CreatedDate'+ CHAR(10) + '     ' +
     ',@RunTime --ETL_UpdateddDate'+ CHAR(10) + '     ' +
     ',0 --ETL_DeletedDate'+ CHAR(10) + '     ' +
     ',NULL --ETL_DeletedDate' + CHAR(10) + '     ,' +
          STUFF ((
                    SELECT ',mySource.[' + name + ']' + CHAR(10) + '     '
						FROM sys.columns
						WHERE object_id = OBJECT_ID(@Target)
                         AND (name NOT LIKE 'ETL[_]%'
                              OR name IN ('ETL_DeltaHashKey', 'ETL_SourceFileName' ) 
						)
					ORDER BY column_id
                    FOR XML PATH('')), 1, 1, '') + ')
;

EXEC etl.LogEventRecordDB @Batchid, ''Info'', @ProcedureName, ''Merge Load'', ''Merge Statement Execution'', ''Complete'', @ExecutionId

DECLARE @MergeInsertRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ' + @Target + ' WHERE ETL_CreatedDate >= @RunTime AND ETL_UpdatedDate = ETL_CreatedDate),''0'');	
DECLARE @MergeUpdateRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ' + @Target + ' WHERE ETL_UpdatedDate >= @RunTime AND ETL_UpdatedDate > ETL_CreatedDate),''0'');	

EXEC etl.LogEventRecordDB @Batchid, ''Info'', @ProcedureName, ''Merge Load'', ''Merge Insert Row Count'', @MergeInsertRowCount, @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, ''Info'', @ProcedureName, ''Merge Load'', ''Merge Update Row Count'', @MergeUpdateRowCount, @ExecutionId


END TRY 
BEGIN CATCH 

	DECLARE @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
	DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
	DECLARE @ErrorState INT = ERROR_STATE();
			
	PRINT @ErrorMessage
	EXEC etl.LogEventRecordDB @Batchid, ''Error'', @ProcedureName, ''Merge Load'', ''Merge Error'', @ErrorMessage, @ExecutionId
	EXEC etl.LogEventRecordDB @Batchid, ''Info'', @ProcedureName, ''Merge Load'', ''Procedure Processing'', ''Complete'', @ExecutionId

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

END CATCH

EXEC etl.LogEventRecordDB @Batchid, ''Info'', @ProcedureName, ''Merge Load'', ''Procedure Processing'', ''Complete'', @ExecutionId


END

GO'

SELECT @SQL AS [SQL], @SQL2 AS [SQL2], @SQL3 AS [SQL3]
;








GO
