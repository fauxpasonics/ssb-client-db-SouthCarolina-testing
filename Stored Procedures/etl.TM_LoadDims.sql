SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[TM_LoadDims]
AS
BEGIN
		
	EXEC [etl].[TM_LoadDimArena]
	EXEC [etl].[TM_LoadDimSeason]
	EXEC [etl].[TM_LoadDimItem]
	EXEC [etl].[TM_LoadDimEvent]	
	EXEC [etl].[TM_LoadDimPlan]
	
	EXEC [etl].[TM_LoadDimLedger] 
	EXEC [etl].[TM_LoadDimClassTM]	
	EXEC [etl].[TM_LoadDimPromo]
	EXEC [etl].[TM_LoadDimSalesCode]

	EXEC [etl].[TM_LoadDimPriceCode]
	EXEC [etl].[TM_LoadDimPriceCodeMaster] 

	EXEC [etl].[TM_LoadDimSeat]
	
	--EXEC [etl].[TM_LoadDimCustomer]

	EXEC mdm.etl.LoadDimCustomer @ClientDB = 'SouthCarolina', @LoadView = 'ods.vw_TM_LoadDimCustomer', @LogLevel = '0', @DropTemp = '0', @IsDataUploaderSource = '0'


END




















































GO
