SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- View

/****** Object:  View [ods].[vw_Fanatics_LoadDimCustomer]    Script Date: 9/20/2016 2:09:03 PM ******/


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
--drop view ods.vw_Fanatics_LoadDimCustomer
CREATE VIEW [ods].[vw_Fanatics_LoadDimCustomer]
AS
    (
      SELECT    *
/*Name*/
              , HASHBYTES('sha2_256',
                          ISNULL(RTRIM(a.Prefix), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.FirstName), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.MiddleName), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.LastName), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.Suffix), 'DBNULL_TEXT')) AS [NameDirtyHash]
              , NULL AS [NameIsCleanStatus]
              , NULL AS [NameMasterId]

/*Address*/
              , HASHBYTES('sha2_256',
                          ISNULL(RTRIM(a.AddressPrimaryStreet), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressPrimaryCity), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressPrimaryState), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressPrimaryZip), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressPrimaryCounty),
                                   'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressPrimaryCountry),
                                   'DBNULL_TEXT')) AS [AddressPrimaryDirtyHash]
              , NULL AS [AddressPrimaryIsCleanStatus]
              , NULL AS [AddressPrimaryMasterId]
              , HASHBYTES('sha2_256',
                          ISNULL(RTRIM(a.AddressOneStreet), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressOneCity), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressOneState), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressOneZip), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressOneCounty), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressOneCountry), 'DBNULL_TEXT')) AS [AddressOneDirtyHash]
              , NULL AS [AddressOneIsCleanStatus]
              , NULL AS [AddressOneMasterId]
              , HASHBYTES('sha2_256',
                          ISNULL(RTRIM(a.AddressTwoStreet), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressTwoCity), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressTwoState), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressTwoZip), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressTwoCounty), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressTwoCountry), 'DBNULL_TEXT')) AS [AddressTwoDirtyHash]
              , NULL AS [AddressTwoIsCleanStatus]
              , NULL AS [AddressTwoMasterId]
              , HASHBYTES('sha2_256',
                          ISNULL(RTRIM(a.AddressThreeStreet), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressThreeCity), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressThreeState), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressThreeZip), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressThreeCounty), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressThreeCountry), 'DBNULL_TEXT')) AS [AddressThreeDirtyHash]
              , NULL AS [AddressThreeIsCleanStatus]
              , NULL AS [AddressThreeMasterId]
              , HASHBYTES('sha2_256',
                          ISNULL(RTRIM(a.AddressFourStreet), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressFourCity), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressFourState), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressFourZip), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressFourCounty), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressFourCountry), 'DBNULL_TEXT')) AS [AddressFourDirtyHash]
              , NULL AS [AddressFourIsCleanStatus]
              , NULL AS [AddressFourMasterId]

/*Contact*/
              , HASHBYTES('sha2_256',
                          ISNULL(RTRIM(a.Prefix), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.FirstName), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.MiddleName), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.LastName), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.Suffix), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressPrimaryStreet),
                                   'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressPrimaryCity), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressPrimaryState), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressPrimaryZip), 'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressPrimaryCounty),
                                   'DBNULL_TEXT')
                          + ISNULL(RTRIM(a.AddressPrimaryCountry),
                                   'DBNULL_TEXT')) AS [ContactDirtyHash]
              , NULL AS [ContactGuid]

/*Phone*/
              , HASHBYTES('sha2_256',
                          ISNULL(RTRIM(a.PhonePrimary), 'DBNULL_TEXT')) AS [PhonePrimaryDirtyHash]
              , NULL AS [PhonePrimaryIsCleanStatus]
              , NULL AS [PhonePrimaryMasterId]
              , HASHBYTES('sha2_256',
                          ISNULL(RTRIM(a.PhoneHome), 'DBNULL_TEXT')) AS [PhoneHomeDirtyHash]
              , NULL AS [PhoneHomeIsCleanStatus]
              , NULL AS [PhoneHomeMasterId]
              , HASHBYTES('sha2_256',
                          ISNULL(RTRIM(a.PhoneCell), 'DBNULL_TEXT')) AS [PhoneCellDirtyHash]
              , NULL AS [PhoneCellIsCleanStatus]
              , NULL AS [PhoneCellMasterId]
              , HASHBYTES('sha2_256',
                          ISNULL(RTRIM(a.PhoneBusiness), 'DBNULL_TEXT')) AS [PhoneBusinessDirtyHash]
              , NULL AS [PhoneBusinessIsCleanStatus]
              , NULL AS [PhoneBusinessMasterId]
              , HASHBYTES('sha2_256', ISNULL(RTRIM(a.PhoneFax), 'DBNULL_TEXT')) AS [PhoneFaxDirtyHash]
              , NULL AS [PhoneFaxIsCleanStatus]
              , NULL AS [PhoneFaxMasterId]
              , HASHBYTES('sha2_256', ISNULL(RTRIM(a.PhoneFax), 'DBNULL_TEXT')) AS [PhoneOtherDirtyHash]
              , NULL AS [PhoneOtherIsCleanStatus]
              , NULL AS [PhoneOtherMasterId]

/*Email*/
              , HASHBYTES('sha2_256',
                          ISNULL(RTRIM(a.EmailPrimary), 'DBNULL_TEXT')) AS [EmailPrimaryDirtyHash]
              , NULL AS [EmailPrimaryIsCleanStatus]
              , NULL AS [EmailPrimaryMasterId]
              , HASHBYTES('sha2_256', ISNULL(RTRIM(a.EmailOne), 'DBNULL_TEXT')) AS [EmailOneDirtyHash]
              , NULL AS [EmailOneIsCleanStatus]
              , NULL AS [EmailOneMasterId]
              , HASHBYTES('sha2_256', ISNULL(RTRIM(a.EmailTwo), 'DBNULL_TEXT')) AS [EmailTwoDirtyHash]
              , NULL AS [EmailTwoIsCleanStatus]
              , NULL AS [EmailTwoMasterId]
      FROM      (
                  --base set
SELECT  DB_NAME() AS [SourceDB]
      , 'Fanatics' AS [SourceSystem]
      , NULL AS [SourceSystemPriority]

/*Standard Attributes*/
      , CAST(SSID AS NVARCHAR(100)) AS [SSID]
      , NULL AS [CustomerType]
      , NULL AS [CustomerStatus]
      , NULL AS [AccountType]
      , NULL AS [AccountRep]
      , NULL AS [CompanyName]
      , NULL AS [SalutationName]
      , NULL AS [DonorMailName]
      , NULL AS [DonorFormalName]
      , CAST(NULL AS DATE) AS [Birthday]
      , NULL AS [Gender]
      , 0 [MergedRecordFlag]
      , NULL [MergedIntoSSID]

/**ENTITIES**/
/*Name*/
      , NULL AS [Prefix]
      , firstName AS [FirstName]
      , NULL AS [MiddleName]
      , LastName AS [LastName]
      , NULL AS [Suffix]
--, c.name_title as [Title]

/*AddressPrimary*/
      , Address1 + ' ' + Address2 AS [AddressPrimaryStreet]
      , City AS [AddressPrimaryCity]
      , [State] AS [AddressPrimaryState]
      , Zip AS [AddressPrimaryZip]
      , NULL AS [AddressPrimaryCounty]
      , Country AS [AddressPrimaryCountry]
      , NULL AS [AddressOneStreet]
      , NULL AS [AddressOneCity]
      , NULL AS [AddressOneState]
      , NULL AS [AddressOneZip]
      , NULL AS [AddressOneCounty]
      , NULL AS [AddressOneCountry]
      , NULL AS [AddressTwoStreet]
      , NULL AS [AddressTwoCity]
      , NULL AS [AddressTwoState]
      , NULL AS [AddressTwoZip]
      , NULL AS [AddressTwoCounty]
      , NULL AS [AddressTwoCountry]
      , NULL AS [AddressThreeStreet]
      , NULL AS [AddressThreeCity]
      , NULL AS [AddressThreeState]
      , NULL AS [AddressThreeZip]
      , NULL AS [AddressThreeCounty]
      , NULL AS [AddressThreeCountry]
      , NULL AS [AddressFourStreet]
      , NULL AS [AddressFourCity]
      , NULL AS [AddressFourState]
      , NULL AS [AddressFourZip]
      , NULL AS [AddressFourCounty]
      , NULL AS [AddressFourCountry] 

/*Phone*/
      , Phone AS [PhonePrimary] --May not be appropriate mapping
      , NULL AS [PhoneHome]
      , NULL AS [PhoneCell]
      , NULL AS [PhoneBusiness]
      , NULL AS [PhoneFax]
      , NULL AS [PhoneOther]

/*Email*/
      , Email AS [EmailPrimary]
      , NULL AS [EmailOne]
      , NULL AS [EmailTwo]

/*Extended Attributes*/
      , NULL AS [ExtAttribute1] --nvarchar(100)
      , NULL AS [ExtAttribute2]
      , NULL AS [ExtAttribute3]
      , NULL AS [ExtAttribute4]
      , NULL AS [ExtAttribute5]
      , NULL AS [ExtAttribute6]
      , NULL AS [ExtAttribute7]
      , NULL AS [ExtAttribute8]
      , NULL AS [ExtAttribute9]
      , NULL AS [ExtAttribute10]
      , NULL AS [ExtAttribute11]
      , --CRMGUID
        NULL AS [ExtAttribute12]
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

/*Source Created and Updated*/
      , NULL [SSCreatedBy]
      , NULL [SSUpdatedBy]
      , NULL [SSCreatedDate]
	  , NULL [CreatedDate]
      , CAST(NULL AS DATE) [SSUpdatedDate]
      , NULL [AccountId]
      , NULL IsBusiness
FROM    dbo.Fanatics_Historical_20160920
WHERE   1 = 1
                ) a
    );



GO
