SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








--select count(*) from [etl].[vw_TI_Load_DimCustomer]




/*****Hash Rules for Reference******
WHEN 'int' THEN 'ISNULL(RTRIM(CONVERT(varchar(10),' + COLUMN_NAME + ')),''DBNULL_INT'')'
WHEN 'bigint' THEN 'ISNULL(RTRIM(CONVERT(varchar(10),' + COLUMN_NAME + ')),''DBNULL_BIGINT'')'
WHEN 'datetime' THEN 'ISNULL(RTRIM(CONVERT(varchar(25),' + COLUMN_NAME + ')),''DBNULL_DATETIME'')'  
WHEN 'datetime2' THEN 'ISNULL(RTRIM(CONVERT(varchar(25),' + COLUMN_NAME + ')),''DBNULL_DATETIME'')'
WHEN 'date' THEN 'ISNULL(RTRIM(CONVERT(varchar(10),' + COLUMN_NAME + ',112)),''DBNULL_DATE'')' 
WHEN 'bit' THEN 'ISNULL(RTRIM(CONVERT(varchar(10),' + COLUMN_NAME + ')),''DBNULL_BIT'')'  
WHEN 'decimal' THEN 'ISNULL(RTRIM(CONVERT(varchar(25),'+ COLUMN_NAME + ')),''DBNULL_NUMBER'')' 
WHEN 'numeric' THEN 'ISNULL(RTRIM(CONVERT(varchar(25),'+ COLUMN_NAME + ')),''DBNULL_NUMBER'')' 
ELSE 'ISNULL(RTRIM(' + COLUMN_NAME + '),''DBNULL_TEXT'')'
*****/
--drop view ods.vw_TM_LoadDimCustomer
--SELECT TOP 10000 * FROM [etl].[vw_TI_Load_DimCustomer]  select top 10000 fullname, firstname, middlename, lastname, * from dbo.dimcustomer
CREATE VIEW [etl].[vw_TI_Load_DimCustomer] AS 


WITH FirstStep (Customer) 
AS (
		SELECT DISTINCT Customer
		FROM dbo.TK_Trans
		WHERE season IN ('CC11','CC12','CC13','CC14','CC15')
		)

	SELECT *
	/*Name*/
	, HASHBYTES('sha2_256',
							ISNULL(RTRIM(FullName),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(Prefix),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(FirstName),'DBNULL_TEXT')
							+ ISNULL(RTRIM(MiddleName),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(LastName),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(Suffix),'DBNULL_TEXT')
							+ ISNULL(RTRIM(CompanyName),'DBNULL_TEXT')
							) AS [NameDirtyHash]
	, NULL AS [NameIsCleanStatus]
	, NULL AS [NameMasterId]

	/*Address*/
	/*Address*/
	, HASHBYTES('sha2_256', ISNULL(RTRIM(AddressPrimaryStreet),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressPrimaryCity),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressPrimaryState),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(AddressPrimaryZip),'DBNULL_TEXT') 
							---+ ISNULL(RTRIM(AddressPrimaryCounty),'DBNULL_TEXT')
							---+ ISNULL(RTRIM(AddressPrimaryCountry),'DBNULL_TEXT')
							) AS [AddressPrimaryDirtyHash]
	, NULL AS [AddressPrimaryIsCleanStatus]
	, NULL AS [AddressPrimaryMasterId]
	, HASHBYTES('sha2_256', ISNULL(RTRIM(AddressOneStreet),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressOneCity),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressOneState),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(AddressOneZip),'DBNULL_TEXT') 
							---+ ISNULL(RTRIM(AddressOneCounty),'DBNULL_TEXT')
							---+ ISNULL(RTRIM(AddressOneCountry),'DBNULL_TEXT')
							) AS [AddressOneDirtyHash]
	, NULL AS [AddressOneIsCleanStatus]
	, NULL AS [AddressOneMasterId]
	, HASHBYTES('sha2_256', ISNULL(RTRIM(AddressTwoStreet),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressTwoCity),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressTwoState),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(AddressTwoZip),'DBNULL_TEXT')
							---+ ISNULL(RTRIM(AddressTwoCounty),'DBNULL_TEXT') 
							---+ ISNULL(RTRIM(AddressTwoCountry),'DBNULL_TEXT')
							) AS [AddressTwoDirtyHash]
	, NULL AS [AddressTwoIsCleanStatus]
	, NULL AS [AddressTwoMasterId]
	, HASHBYTES('sha2_256', ISNULL(RTRIM(AddressThreeStreet),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressThreeCity),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressThreeState),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(AddressThreeZip),'DBNULL_TEXT') 
							---+ ISNULL(RTRIM(AddressThreeCounty),'DBNULL_TEXT')
							---+ ISNULL(RTRIM(AddressThreeCountry),'DBNULL_TEXT')
							) AS [AddressThreeDirtyHash]
	, NULL AS [AddressThreeIsCleanStatus]
	, NULL AS [AddressThreeMasterId]
	, HASHBYTES('sha2_256', ISNULL(RTRIM(AddressFourStreet),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressFourCity),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressFourState),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(AddressFourZip),'DBNULL_TEXT')
							---+ ISNULL(RTRIM(AddressFourCounty),'DBNULL_TEXT') 
							---+ ISNULL(RTRIM(AddressFourCountry),'DBNULL_TEXT')
							) AS [AddressFourDirtyHash]
	, NULL AS [AddressFourIsCleanStatus]
	, NULL AS [AddressFourMasterId]

	/*Contact*/
	, NULL AS [ContactDirtyHash]
	, CAST(NULL AS UNIQUEIDENTIFIER) AS [ContactGuid]

	/*Phone*/
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(PhonePrimary),'DBNULL_TEXT')) AS [PhonePrimaryDirtyHash]
	, NULL AS [PhonePrimaryIsCleanStatus]
	, NULL AS [PhonePrimaryMasterId]
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(PhoneHome),'DBNULL_TEXT')) AS [PhoneHomeDirtyHash]
	, NULL AS [PhoneHomeIsCleanStatus]
	, NULL AS [PhoneHomeMasterId]
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(PhoneCell),'DBNULL_TEXT')) AS [PhoneCellDirtyHash]
	, NULL AS [PhoneCellIsCleanStatus]
	, NULL AS [PhoneCellMasterId]
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(PhoneBusiness),'DBNULL_TEXT')) AS [PhoneBusinessDirtyHash]
	, NULL AS [PhoneBusinessIsCleanStatus]
	, NULL AS [PhoneBusinessMasterId]
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(PhoneFax),'DBNULL_TEXT')) AS [PhoneFaxDirtyHash]
	, NULL AS [PhoneFaxIsCleanStatus]
	, NULL AS [PhoneFaxMasterId]
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(PhoneOther),'DBNULL_TEXT')) AS [PhoneOtherDirtyHash]
	, NULL AS [PhoneOtherIsCleanStatus]
	, NULL AS [PhoneOtherMasterId]

	/*Email*/
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(EmailPrimary),'DBNULL_TEXT')) AS [EmailPrimaryDirtyHash]
	, NULL AS [EmailPrimaryIsCleanStatus]
	, NULL AS [EmailPrimaryMasterId]
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(EmailOne),'DBNULL_TEXT')) AS [EmailOneDirtyHash]
	, NULL AS [EmailOneIsCleanStatus]
	, NULL AS [EmailOneMasterId]
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(EmailTwo),'DBNULL_TEXT')) AS [EmailTwoDirtyHash]
	, NULL AS [EmailTwoIsCleanStatus]
	, NULL AS [EmailTwoMasterId]

	, HASHBYTES('sha2_256', ISNULL(RTRIM(customerType),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(CustomerStatus),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AccountType),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(AccountRep),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(CompanyName),'DBNULL_TEXT')
							+ ISNULL(RTRIM(SalutationName),'DBNULL_TEXT')
							+ ISNULL(RTRIM(DonorMailName),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(DonorFormalName),'DBNULL_TEXT')
							+ ISNULL(RTRIM(Birthday),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(Gender),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AccountId),'DBNULL_TEXT')
							+ ISNULL(RTRIM(MergedRecordFlag),'DBNULL_TEXT')
							+ ISNULL(RTRIM(MergedIntoSSID),'DBNULL_TEXT')
							+ ISNULL(RTRIM(IsBusiness),'DBNULL_TEXT')) AS [contactattrDirtyHash]

	, HASHBYTES('sha2_256', ISNULL(RTRIM(ExtAttribute1),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute2),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute3),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(ExtAttribute4),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute5),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute6),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute7),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute8),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute9),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(ExtAttribute10),'DBNULL_TEXT') 
							) AS [extattr1_10DirtyHash]

							, HASHBYTES('sha2_256', ISNULL(RTRIM(ExtAttribute11),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute12),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute13),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(ExtAttribute14),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute15),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute16),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute17),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute18),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute19),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(ExtAttribute20),'DBNULL_TEXT') 
							) AS [extattr11_20DirtyHash]

							
	, HASHBYTES('sha2_256', ISNULL(RTRIM(ExtAttribute21),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute22),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute23),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(ExtAttribute24),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute25),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute26),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute27),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute28),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute29),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(ExtAttribute30),'DBNULL_TEXT') 
							) AS [extattr21_30DirtyHash]

							
	, HASHBYTES('sha2_256', ISNULL(RTRIM(ExtAttribute31),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute32),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute33),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(ExtAttribute34),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute35),'DBNULL_TEXT')
							) AS [extattr31_35DirtyHash]
	





	FROM (
--base set
/*
SELECT TOP 100 *
FROM ods.TI_PatronMDM
*/

		SELECT 
			'SouthCarolina' AS [SourceDB]
			, 'PAC_CLA' AS [SourceSystem]
			, NULL AS [SourceSystemPriority]

			/*Standard Attributes*/
			, CAST(Patron AS NVARCHAR(25)) [SSID]
			, CAST(CustomerType AS NVARCHAR(50)) AS [CustomerType]
			, CAST(CustomerStatus AS NVARCHAR(50)) AS [CustomerStatus]
			, CAST(NULL AS NVARCHAR(50)) AS [AccountType] 
			, CAST(NULL AS NVARCHAR(50)) AS [AccountRep] 
			, CAST(CASE WHEN FullName LIKE '%,%' THEN NULL ELSE FullName END AS NVARCHAR(50)) AS [CompanyName] 
			, NULL AS [SalutationName]
			, NULL AS [DonorMailName]
			, NULL AS [DonorFormalName]
			, CAST(NULL AS DATE) AS [Birthday]
			, NULL AS [Gender] 
			, 0 [MergedRecordFlag]
			, NULL [MergedIntoSSID]

			/**ENTITIES**/
			/*Name*/			
			, LEFT(FullName,200) AS FullName
			, LEFT(Title,100) AS [Prefix]
		
			, CASE
			       WHEN CHARINDEX(',',[FullName]) > 0 THEN LEFT([FullName], (CHARINDEX(',',[FullName])-1)) --if there's a comma, return everything to the left of it
			  END AS [LastName]
			, NULL AS [MiddleName]
			, CASE 
					WHEN Sal_f IS NOT NULL THEN LEFT(sal_f,100)
				    WHEN sal_n1 IS NOT NULL THEN LEFT(sal_n1,100)
					WHEN CHARINDEX(',',[FullName]) > 0 THEN LTRIM(SUBSTRING([FullName],((CHARINDEX(',',[FullName]))+1),(LEN([FullName])))) --if there's a comma, get everything to the right
				ELSE NULL END AS  [FirstName]
		
			, LEFT(Suffix,100) AS [Suffix]
			--, c.name_title as [Title]

			/*AddressPrimary*/
			, CASE WHEN PrimaryAddressType = 'H' THEN LEFT(PrimaryAddressStreet,500)
				ELSE COALESCE(Address2Street, Address3Street, Address4Street, Address5Street) END AS [AddressPrimaryStreet]
			, CASE WHEN PrimaryAddressType = 'H' THEN LEFT(PrimaryAddressCity,200)
				ELSE COALESCE(Address2City, Address3City, Address4City, Address5City) END AS [AddressPrimaryCity] 
			, CASE WHEN primaryaddresstype = 'H' THEN LEFT(PrimaryAddressState,200)
				ELSE COALESCE(Address2state, Address3State, Address4State, Address5State) END AS [AddressPrimaryState] 
			, CASE WHEN PrimaryAddressType = 'H' THEN LEFT(PrimaryAddressZipCode,25)
				ELSE COALESCE (Address2ZipCode, Address3ZipCode, Address4ZipCode, Address5ZipCode) END AS [AddressPrimaryZip] 
			, NULL AS [AddressPrimaryCounty]
			, CASE WHEN PrimaryAddressType = 'H' THEN LEFT(PrimaryAddressCountry,200)
			    ELSE COALESCE(Address2Country, Address3Country,Address4Country,Address5Country) END AS [AddressPrimaryCountry] 
			
			, Address2Street AS [AddressOneStreet]
			, Address2City AS [AddressOneCity] 
			, Address2State AS [AddressOneState] 
			, Address2ZipCode AS [AddressOneZip] 
			, NULL AS [AddressOneCounty] 
			, Address2Country AS [AddressOneCountry] 

			, Address3Street AS [AddressTwoStreet]
			, Address3City AS [AddressTwoCity] 
			, Address3State AS [AddressTwoState] 
			, Address3ZipCode AS [AddressTwoZip] 
			, NULL AS [AddressTwoCounty] 
			, Address3Country AS [AddressTwoCountry] 

			, Address4Street AS [AddressThreeStreet]
			, Address4City AS [AddressThreeCity] 
			, Address4State AS [AddressThreeState] 
			, Address4ZipCode AS [AddressThreeZip] 
			, NULL AS [AddressThreeCounty] 
			, Address4Country AS [AddressThreeCountry] 
			
			, Address5Street AS [AddressFourStreet]
			, Address5City AS [AddressFourCity] 
			, Address5State AS [AddressFourState] 
			, Address5ZipCode AS [AddressFourZip] 
			, NULL AS [AddressFourCounty]
			, Address5Country AS [AddressFourCountry] 

			/*Phone*/

			, ISNULL(CAST(businessphone AS NVARCHAR(25)), CAST(p.HomePhone AS NVARCHAR(25))) PhonePrimary
			, CAST(HomePhone AS NVARCHAR(25)) AS [PhoneHome]
			, CAST(CellPhone AS NVARCHAR(25)) AS [PhoneCell]
			, CAST(BusinessPhone AS NVARCHAR(25)) AS [PhoneBusiness]
			, CAST(Fax AS NVARCHAR(25)) AS [PhoneFax]
			, CAST(OtherPhone AS NVARCHAR(25)) AS [PhoneOther]

			/*Email*/
			, COALESCE(p.[PersonalEmail],P.BusinessEmail) AS [EmailPrimary]
			, p.PersonalEmail AS [EmailOne] --phone type E 
			, p.BusinessEmail AS [EmailTwo]

			/*Extended Attributes*/
			, NULL AS[ExtAttribute1] --nvarchar(100)
			, NULL AS[ExtAttribute2] 
			, NULL AS[ExtAttribute3] 
			, NULL AS[ExtAttribute4] 
			, NULL AS[ExtAttribute5] 
			, NULL AS[ExtAttribute6] 
			, NULL AS[ExtAttribute7] 
			, NULL AS[ExtAttribute8] 
			, NULL AS[ExtAttribute9] 
			, NULL AS[ExtAttribute10] 

			, NULL AS [ExtAttribute11] 
			, NULL AS [ExtAttribute12] 
			, NULL AS [ExtAttribute13] 
			, NULL AS [ExtAttribute14] 
			, NULL AS [ExtAttribute15] 
			, NULL AS [ExtAttribute16] 
			, NULL AS [ExtAttribute17] 
			, NULL AS [ExtAttribute18] 
			, NULL AS [ExtAttribute19] 
			, NULL AS [ExtAttribute20]  

			, NULL AS [ExtAttribute21] --datetime
			, NULL AS [ExtAttribute22] 
			, NULL AS [ExtAttribute23] 
			, NULL AS [ExtAttribute24] 
			, NULL AS [ExtAttribute25] 
			, NULL AS [ExtAttribute26] 
			, NULL AS [ExtAttribute27] 
			, NULL AS [ExtAttribute28] 
			, NULL AS [ExtAttribute29] 
			, NULL AS [ExtAttribute30]  

			, p.External_number AS [ExtAttribute31]
			--, p.UD1 AS [ExtAttribute32]
			--, p.UD2 AS [ExtAttribute33] 
			, NULL AS [ExtAttribute32]
			, NULL AS [ExtAttribute33]
			, NULL AS [ExtAttribute34]
			, NULL AS [ExtAttribute35]

			/*Source Created and Updated*/
			, NULL [SSCreatedBy]
			, NULL [SSUpdatedBy]
			, PacCreateDate [SSCreatedDate]
			, CAST(PacCreateDate AS DATETIME) [CreatedDate]
			, UpdatedDate [SSUpdatedDate]

			, NULL [AccountId]
			, CAST(CASE WHEN FullName LIKE '%,%' THEN 0 ELSE 1 END AS BIT) IsBusiness
			, NULL customer_MatchKey
		--Select TOP 10 *
		FROM etl.vwTI_PatronMDM p		
		WHERE 1=1
		AND Patron IN (SELECT Customer FROM FirstStep)
		--and UD4 is not null
		--AND LEN(FullName) > 3
		--AND updatedate > (GETDATE() - 2)
		--AND Patron = '102394'



		--AND (PacCreateDate > (GETDATE() - 10) OR UpdatedDate > (GETDATE() - 10)) 
	) a





















































GO
