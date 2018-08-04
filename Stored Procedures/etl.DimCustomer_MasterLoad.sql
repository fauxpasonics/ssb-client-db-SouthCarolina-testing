SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [etl].[DimCustomer_MasterLoad]

AS
BEGIN


-- Turnkey
EXEC mdm.etl.LoadDimCustomer @ClientDB = 'SouthCarolina', @LoadView = '[etl].[vw_Load_DimCustomer_Turnkey]', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'


-- SFDC Contacts
EXEC mdm.etl.LoadDimCustomer @ClientDB = 'SouthCarolina', @LoadView = '[etl].[vw_Load_DimCustomer_SFDCContact]', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'


--SFDC Contacts deletes
UPDATE b
	SET b.IsDeleted = a.IsDeleted
	,deletedate = getdate()
	--SELECT a.IsDeleted
	--SELECT COUNT(*) 
	FROM SouthCarolina_reporting.ProdCopy.Contact a 
	INNER JOIN dbo.DimCustomer b ON a.id = b.SSID AND b.SourceSystem = 'SouthCarolina PC_SFDC Contact'
	WHERE a.IsDeleted <> b.IsDeleted

-- SFDC Accounts
EXEC mdm.etl.LoadDimCustomer @ClientDB = 'SouthCarolina', @LoadView = '[etl].[vw_Load_DimCustomer_SFDCAccount]', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'


--SFDC Accounts deletes
UPDATE b
	SET b.IsDeleted = a.IsDeleted
	,deletedate = getdate()
	--SELECT a.IsDeleted
	--SELECT COUNT(*) 
	FROM SouthCarolina_reporting.ProdCopy.Account a 
	INNER JOIN dbo.DimCustomer b ON a.id = b.SSID AND b.SourceSystem = 'SouthCarolina PC_SFDC Account'
	WHERE a.IsDeleted <> b.IsDeleted

--TM matchkeys
UPDATE b
	SET Customer_Matchkey = 'TM-' +CAST(AccountId as varchar)
	--SELECT a.IsDeleted
	--SELECT COUNT(*) 
	FROM dbo.DimCustomer b 
	WHERE Sourcesystem = 'TM'
	AND CustomerType = 'primary'
	AND ISNULL(Customer_Matchkey,'') <> 'TM-' +CAST(AccountId as varchar)

END
GO
