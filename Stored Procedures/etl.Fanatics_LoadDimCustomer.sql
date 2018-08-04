SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  StoredProcedure [etl].[Fanatics_LoadDimCustomer]    Script Date: 9/20/2016 2:07:36 PM ******/





CREATE PROCEDURE [etl].[Fanatics_LoadDimCustomer]
AS
    BEGIN

--select * From dbo.DimCustomerStaging

        DECLARE @RunTime DATETIME = GETDATE();

/***Name***/
        MERGE dbo.DimCustomer AS myTarget
        USING
            (
              SELECT    *
              FROM      ods.vw_Fanatics_LoadDimCustomer
            ) AS mySource
        ON myTarget.SourceDB = mySource.SourceDB
            AND myTarget.SourceSystem = mySource.SourceSystem
            AND myTarget.SSID = mySource.SSID
        WHEN MATCHED AND ISNULL(mySource.NameDirtyHash, -1) <> ISNULL(myTarget.NameDirtyHash,
                                                              -1) THEN
            UPDATE SET
                    myTarget.SourceDB = mySource.SourceDB
                  , myTarget.SourceSystem = mySource.SourceSystem
                  , myTarget.SourceSystemPriority = mySource.SourceSystemPriority
                  , myTarget.SSID = mySource.SSID

	/* Moved to its own independent merge at the end, with the ExtAttributes
	, myTarget.CustomerType = mySource.CustomerType
	, myTarget.CustomerStatus = mySource.CustomerStatus
	, myTarget.AccountType = mySource.AccountType
	, myTarget.AccountRep = mySource.AccountRep
	, myTarget.CompanyName = mySource.CompanyName
	, myTarget.Birthday = mySource.Birthday
	, myTarget.Gender = mySource.Gender
	, myTarget.MergedRecordFlag = mySource.MergedRecordFlag
	, myTarget.MergedIntoSSID = mySource.MergedIntoSSID
	*/
                  , myTarget.Prefix = mySource.Prefix
                  , myTarget.FirstName = mySource.FirstName
                  , myTarget.MiddleName = mySource.MiddleName
                  , myTarget.LastName = mySource.LastName
                  , myTarget.Suffix = mySource.Suffix
	--, myTarget.Title = mySource.Title
                  , myTarget.NameDirtyHash = mySource.NameDirtyHash
                  , myTarget.NameIsCleanStatus = 'Dirty'
                  , myTarget.SSCreatedBy = mySource.SSCreatedBy
                  , myTarget.SSUpdatedBy = mySource.SSUpdatedBy
                  , myTarget.SSCreatedDate = mySource.SSCreatedDate
                  , myTarget.SSUpdatedDate = mySource.SSUpdatedDate
                  , myTarget.UpdatedBy = 'CI'
                  , myTarget.UpdatedDate = @RunTime
        WHEN NOT MATCHED THEN
            INSERT (
                     SourceDB
                   , SourceSystem
                   , SourceSystemPriority
                   , SSID
                   , NameDirtyHash
                   , NameIsCleanStatus
                   , /*CustomerType, CustomerStatus, AccountType, AccountRep, CompanyName, Birthday, Gender, MergedRecordFlag, MergedIntoSSID,*/ Prefix
                   , FirstName
                   , MiddleName
                   , LastName
                   , Suffix
                   , SSCreatedBy
                   , SSUpdatedBy
                   , SSCreatedDate
                   , SSUpdatedDate
                   , CreatedBy
                   , UpdatedBy
                   , CreatedDate
                   , UpdatedDate
                   )
            VALUES (
                     mySource.SourceDB
                   , mySource.SourceSystem
                   , mySource.SourceSystemPriority
                   , mySource.SSID
                   , mySource.NameDirtyHash
                   , 'Dirty' --NameIsCleanStatus
		
		/*
		, mySource.CustomerType
		, mySource.CustomerStatus
		, mySource.AccountType
		, mySource.AccountRep
		, mySource.CompanyName
		, mySource.Birthday
		, mySource.Gender
		, mySource.MergedRecordFlag
		, mySource.MergedIntoSSID
		*/
                   , mySource.Prefix
                   , mySource.FirstName
                   , mySource.MiddleName
                   , mySource.LastName
                   , mySource.Suffix
		--, mySource.Title
                   , mySource.SSCreatedBy
                   , mySource.SSUpdatedBy
                   , mySource.SSCreatedDate
                   , mySource.SSUpdatedDate
                   , 'CI' --CreatedBy
                   , 'CI' --UpdatedBy
                   , @RunTime --CreatedDate
                   , @RunTime --UpdatedDate
                   );

/***AddressPrimary***/
        MERGE dbo.DimCustomer AS myTarget
        USING
            (
              SELECT    *
              FROM      ods.vw_Fanatics_LoadDimCustomer
            ) AS mySource
        ON myTarget.SourceDB = mySource.SourceDB
            AND myTarget.SourceSystem = mySource.SourceSystem
            AND myTarget.SSID = mySource.SSID
        WHEN MATCHED AND ISNULL(mySource.AddressPrimaryDirtyHash, -1) <> ISNULL(myTarget.AddressPrimaryDirtyHash,
                                                              -1) THEN
            UPDATE SET
                    myTarget.SourceDB = mySource.SourceDB
                  , myTarget.SourceSystem = mySource.SourceSystem
                  , myTarget.SSID = mySource.SSID
                  , myTarget.AddressPrimaryDirtyHash = mySource.AddressPrimaryDirtyHash
                  , myTarget.AddressPrimaryIsCleanStatus = 'Dirty'
                  , myTarget.AddressPrimaryStreet = mySource.AddressPrimaryStreet
                  , myTarget.AddressPrimaryCity = mySource.AddressPrimaryCity
                  , myTarget.AddressPrimaryState = mySource.AddressPrimaryState
                  , myTarget.AddressPrimaryZip = mySource.AddressPrimaryZip
                  , myTarget.AddressPrimaryCounty = mySource.AddressPrimaryCounty
                  , myTarget.AddressPrimaryCountry = mySource.AddressPrimaryCountry
                  , myTarget.ContactDirtyHash = mySource.ContactDirtyHash
	--, myTarget.ContactGUID = mySource.ContactGUID
                  , myTarget.SSCreatedBy = mySource.SSCreatedBy
                  , myTarget.SSUpdatedBy = mySource.SSUpdatedBy
                  , myTarget.SSCreatedDate = mySource.SSCreatedDate
                  , myTarget.SSUpdatedDate = mySource.SSUpdatedDate
                  , myTarget.UpdatedBy = 'CI'
                  , myTarget.UpdatedDate = @RunTime;


/***AddressOne***/
        MERGE dbo.DimCustomer AS myTarget
        USING
            (
              SELECT    *
              FROM      ods.vw_Fanatics_LoadDimCustomer
            ) AS mySource
        ON myTarget.SourceDB = mySource.SourceDB
            AND myTarget.SourceSystem = mySource.SourceSystem
            AND myTarget.SSID = mySource.SSID
        WHEN MATCHED AND ISNULL(mySource.AddressOneDirtyHash, -1) <> ISNULL(myTarget.AddressOneDirtyHash,
                                                              -1) THEN
            UPDATE SET
                    myTarget.SourceDB = mySource.SourceDB
                  , myTarget.SourceSystem = mySource.SourceSystem
                  , myTarget.SSID = mySource.SSID
                  , myTarget.AddressOneDirtyHash = mySource.AddressOneDirtyHash
                  , myTarget.AddressOneIsCleanStatus = 'Dirty'
                  , myTarget.AddressOneStreet = mySource.AddressOneStreet
                  , myTarget.AddressOneCity = mySource.AddressOneCity
                  , myTarget.AddressOneState = mySource.AddressOneState
                  , myTarget.AddressOneZip = mySource.AddressOneZip
                  , myTarget.AddressOneCounty = mySource.AddressOneCounty
                  , myTarget.AddressOneCountry = mySource.AddressOneCountry
                  , myTarget.SSCreatedBy = mySource.SSCreatedBy
                  , myTarget.SSUpdatedBy = mySource.SSUpdatedBy
                  , myTarget.SSCreatedDate = mySource.SSCreatedDate
                  , myTarget.SSUpdatedDate = mySource.SSUpdatedDate
                  , myTarget.UpdatedBy = 'CI'
                  , myTarget.UpdatedDate = @RunTime;

/***AddressTwo***/
        MERGE dbo.DimCustomer AS myTarget
        USING
            (
              SELECT    *
              FROM      ods.vw_Fanatics_LoadDimCustomer
            ) AS mySource
        ON myTarget.SourceDB = mySource.SourceDB
            AND myTarget.SourceSystem = mySource.SourceSystem
            AND myTarget.SSID = mySource.SSID
        WHEN MATCHED AND ISNULL(mySource.AddressTwoDirtyHash, -1) <> ISNULL(myTarget.AddressTwoDirtyHash,
                                                              -1) THEN
            UPDATE SET
                    myTarget.SourceDB = mySource.SourceDB
                  , myTarget.SourceSystem = mySource.SourceSystem
                  , myTarget.SSID = mySource.SSID
                  , myTarget.AddressTwoDirtyHash = mySource.AddressTwoDirtyHash
                  , myTarget.AddressTwoIsCleanStatus = 'Dirty'
                  , myTarget.AddressTwoStreet = mySource.AddressTwoStreet
                  , myTarget.AddressTwoCity = mySource.AddressTwoCity
                  , myTarget.AddressTwoState = mySource.AddressTwoState
                  , myTarget.AddressTwoZip = mySource.AddressTwoZip
                  , myTarget.AddressTwoCounty = mySource.AddressTwoCounty
                  , myTarget.AddressTwoCountry = mySource.AddressTwoCountry
                  , myTarget.SSCreatedBy = mySource.SSCreatedBy
                  , myTarget.SSUpdatedBy = mySource.SSUpdatedBy
                  , myTarget.SSCreatedDate = mySource.SSCreatedDate
                  , myTarget.SSUpdatedDate = mySource.SSUpdatedDate
                  , myTarget.UpdatedBy = 'CI'
                  , myTarget.UpdatedDate = @RunTime;

/***AddressThree***/
        MERGE dbo.DimCustomer AS myTarget
        USING
            (
              SELECT    *
              FROM      ods.vw_Fanatics_LoadDimCustomer
            ) AS mySource
        ON myTarget.SourceDB = mySource.SourceDB
            AND myTarget.SourceSystem = mySource.SourceSystem
            AND myTarget.SSID = mySource.SSID
        WHEN MATCHED AND ISNULL(mySource.AddressThreeDirtyHash, -1) <> ISNULL(myTarget.AddressThreeDirtyHash,
                                                              -1) THEN
            UPDATE SET
                    myTarget.SourceDB = mySource.SourceDB
                  , myTarget.SourceSystem = mySource.SourceSystem
                  , myTarget.SSID = mySource.SSID
                  , myTarget.AddressThreeDirtyHash = mySource.AddressThreeDirtyHash
                  , myTarget.AddressThreeIsCleanStatus = 'Dirty'
                  , myTarget.AddressThreeStreet = mySource.AddressThreeStreet
                  , myTarget.AddressThreeCity = mySource.AddressThreeCity
                  , myTarget.AddressThreeState = mySource.AddressThreeState
                  , myTarget.AddressThreeZip = mySource.AddressThreeZip
                  , myTarget.AddressThreeCounty = mySource.AddressThreeCounty
                  , myTarget.AddressThreeCountry = mySource.AddressThreeCountry
                  , myTarget.SSCreatedBy = mySource.SSCreatedBy
                  , myTarget.SSUpdatedBy = mySource.SSUpdatedBy
                  , myTarget.SSCreatedDate = mySource.SSCreatedDate
                  , myTarget.SSUpdatedDate = mySource.SSUpdatedDate
                  , myTarget.UpdatedBy = 'CI'
                  , myTarget.UpdatedDate = @RunTime;

/***AddressFour***/
        MERGE dbo.DimCustomer AS myTarget
        USING
            (
              SELECT    *
              FROM      ods.vw_Fanatics_LoadDimCustomer
            ) AS mySource
        ON myTarget.SourceDB = mySource.SourceDB
            AND myTarget.SourceSystem = mySource.SourceSystem
            AND myTarget.SSID = mySource.SSID
        WHEN MATCHED AND ISNULL(mySource.AddressFourDirtyHash, -1) <> ISNULL(myTarget.AddressFourDirtyHash,
                                                              -1) THEN
            UPDATE SET
                    myTarget.SourceDB = mySource.SourceDB
                  , myTarget.SourceSystem = mySource.SourceSystem
                  , myTarget.SSID = mySource.SSID
                  , myTarget.AddressFourDirtyHash = mySource.AddressFourDirtyHash
                  , myTarget.AddressFourIsCleanStatus = 'Dirty'
                  , myTarget.AddressFourStreet = mySource.AddressFourStreet
                  , myTarget.AddressFourCity = mySource.AddressFourCity
                  , myTarget.AddressFourState = mySource.AddressFourState
                  , myTarget.AddressFourZip = mySource.AddressFourZip
                  , myTarget.AddressFourCounty = mySource.AddressFourCounty
                  , myTarget.AddressFourCountry = mySource.AddressFourCountry
                  , myTarget.SSCreatedBy = mySource.SSCreatedBy
                  , myTarget.SSUpdatedBy = mySource.SSUpdatedBy
                  , myTarget.SSCreatedDate = mySource.SSCreatedDate
                  , myTarget.SSUpdatedDate = mySource.SSUpdatedDate
                  , myTarget.UpdatedBy = 'CI'
                  , myTarget.UpdatedDate = @RunTime;

/***PhonePrimary***/
        MERGE dbo.DimCustomer AS myTarget
        USING
            (
              SELECT    *
              FROM      ods.vw_Fanatics_LoadDimCustomer
            ) AS mySource
        ON myTarget.SourceDB = mySource.SourceDB
            AND myTarget.SourceSystem = mySource.SourceSystem
            AND myTarget.SSID = mySource.SSID
        WHEN MATCHED AND ISNULL(mySource.PhonePrimaryDirtyHash, -1) <> ISNULL(myTarget.PhonePrimaryDirtyHash,
                                                              -1) THEN
            UPDATE SET
                    myTarget.SourceDB = mySource.SourceDB
                  , myTarget.SourceSystem = mySource.SourceSystem
                  , myTarget.SSID = mySource.SSID
                  , myTarget.PhonePrimaryDirtyHash = mySource.PhonePrimaryDirtyHash
                  , myTarget.PhonePrimaryIsCleanStatus = 'Dirty'
                  , myTarget.PhonePrimary = mySource.PhonePrimary
                  , myTarget.SSCreatedBy = mySource.SSCreatedBy
                  , myTarget.SSUpdatedBy = mySource.SSUpdatedBy
                  , myTarget.SSCreatedDate = mySource.SSCreatedDate
                  , myTarget.SSUpdatedDate = mySource.SSUpdatedDate
                  , myTarget.UpdatedBy = 'CI'
                  , myTarget.UpdatedDate = @RunTime;

/***PhoneHome***/
        MERGE dbo.DimCustomer AS myTarget
        USING
            (
              SELECT    *
              FROM      ods.vw_Fanatics_LoadDimCustomer
            ) AS mySource
        ON myTarget.SourceDB = mySource.SourceDB
            AND myTarget.SourceSystem = mySource.SourceSystem
            AND myTarget.SSID = mySource.SSID
        WHEN MATCHED AND ISNULL(mySource.PhoneHomeDirtyHash, -1) <> ISNULL(myTarget.PhoneHomeDirtyHash,
                                                              -1) THEN
            UPDATE SET
                    myTarget.SourceDB = mySource.SourceDB
                  , myTarget.SourceSystem = mySource.SourceSystem
                  , myTarget.SSID = mySource.SSID
                  , myTarget.PhoneHomeDirtyHash = mySource.PhoneHomeDirtyHash
                  , myTarget.PhoneHomeIsCleanStatus = 'Dirty'
                  , myTarget.PhoneHome = mySource.PhoneHome
                  , myTarget.SSCreatedBy = mySource.SSCreatedBy
                  , myTarget.SSUpdatedBy = mySource.SSUpdatedBy
                  , myTarget.SSCreatedDate = mySource.SSCreatedDate
                  , myTarget.SSUpdatedDate = mySource.SSUpdatedDate
                  , myTarget.UpdatedBy = 'CI'
                  , myTarget.UpdatedDate = @RunTime;

/***PhoneCell***/
        MERGE dbo.DimCustomer AS myTarget
        USING
            (
              SELECT    *
              FROM      ods.vw_Fanatics_LoadDimCustomer
            ) AS mySource
        ON myTarget.SourceDB = mySource.SourceDB
            AND myTarget.SourceSystem = mySource.SourceSystem
            AND myTarget.SSID = mySource.SSID
        WHEN MATCHED AND ISNULL(mySource.PhoneCellDirtyHash, -1) <> ISNULL(myTarget.PhoneCellDirtyHash,
                                                              -1) THEN
            UPDATE SET
                    myTarget.SourceDB = mySource.SourceDB
                  , myTarget.SourceSystem = mySource.SourceSystem
                  , myTarget.SSID = mySource.SSID
                  , myTarget.PhoneCellDirtyHash = mySource.PhoneCellDirtyHash
                  , myTarget.PhoneCellIsCleanStatus = 'Dirty'
                  , myTarget.PhoneCell = mySource.PhoneCell
                  , myTarget.SSCreatedBy = mySource.SSCreatedBy
                  , myTarget.SSUpdatedBy = mySource.SSUpdatedBy
                  , myTarget.SSCreatedDate = mySource.SSCreatedDate
                  , myTarget.SSUpdatedDate = mySource.SSUpdatedDate
                  , myTarget.UpdatedBy = 'CI'
                  , myTarget.UpdatedDate = @RunTime;

/***PhoneBusiness***/
        MERGE dbo.DimCustomer AS myTarget
        USING
            (
              SELECT    *
              FROM      ods.vw_Fanatics_LoadDimCustomer
            ) AS mySource
        ON myTarget.SourceDB = mySource.SourceDB
            AND myTarget.SourceSystem = mySource.SourceSystem
            AND myTarget.SSID = mySource.SSID
        WHEN MATCHED AND ISNULL(mySource.PhoneBusinessDirtyHash, -1) <> ISNULL(myTarget.PhoneBusinessDirtyHash,
                                                              -1) THEN
            UPDATE SET
                    myTarget.SourceDB = mySource.SourceDB
                  , myTarget.SourceSystem = mySource.SourceSystem
                  , myTarget.SSID = mySource.SSID
                  , myTarget.PhoneBusinessDirtyHash = mySource.PhoneBusinessDirtyHash
                  , myTarget.PhoneBusinessIsCleanStatus = 'Dirty'
                  , myTarget.PhoneBusiness = mySource.PhoneBusiness
                  , myTarget.SSCreatedBy = mySource.SSCreatedBy
                  , myTarget.SSUpdatedBy = mySource.SSUpdatedBy
                  , myTarget.SSCreatedDate = mySource.SSCreatedDate
                  , myTarget.SSUpdatedDate = mySource.SSUpdatedDate
                  , myTarget.UpdatedBy = 'CI'
                  , myTarget.UpdatedDate = @RunTime;

/***PhoneFax***/
        MERGE dbo.DimCustomer AS myTarget
        USING
            (
              SELECT    *
              FROM      ods.vw_Fanatics_LoadDimCustomer
            ) AS mySource
        ON myTarget.SourceDB = mySource.SourceDB
            AND myTarget.SourceSystem = mySource.SourceSystem
            AND myTarget.SSID = mySource.SSID
        WHEN MATCHED AND ISNULL(mySource.PhoneFaxDirtyHash, -1) <> ISNULL(myTarget.PhoneFaxDirtyHash,
                                                              -1) THEN
            UPDATE SET
                    myTarget.SourceDB = mySource.SourceDB
                  , myTarget.SourceSystem = mySource.SourceSystem
                  , myTarget.SSID = mySource.SSID
                  , myTarget.PhoneFaxDirtyHash = mySource.PhoneFaxDirtyHash
                  , myTarget.PhoneFaxIsCleanStatus = 'Dirty'
                  , myTarget.PhoneFax = mySource.PhoneFax
                  , myTarget.SSCreatedBy = mySource.SSCreatedBy
                  , myTarget.SSUpdatedBy = mySource.SSUpdatedBy
                  , myTarget.SSCreatedDate = mySource.SSCreatedDate
                  , myTarget.SSUpdatedDate = mySource.SSUpdatedDate
                  , myTarget.UpdatedBy = 'CI'
                  , myTarget.UpdatedDate = @RunTime;


/***PhoneOther***/
        MERGE dbo.DimCustomer AS myTarget
        USING
            (
              SELECT    *
              FROM      ods.vw_Fanatics_LoadDimCustomer
            ) AS mySource
        ON myTarget.SourceDB = mySource.SourceDB
            AND myTarget.SourceSystem = mySource.SourceSystem
            AND myTarget.SSID = mySource.SSID
        WHEN MATCHED AND ISNULL(mySource.PhoneOtherDirtyHash, -1) <> ISNULL(myTarget.PhoneOtherDirtyHash,
                                                              -1) THEN
            UPDATE SET
                    myTarget.SourceDB = mySource.SourceDB
                  , myTarget.SourceSystem = mySource.SourceSystem
                  , myTarget.SSID = mySource.SSID
                  , myTarget.PhoneOtherDirtyHash = mySource.PhoneOtherDirtyHash
                  , myTarget.PhoneOtherIsCleanStatus = 'Dirty'
                  , myTarget.PhoneOther = mySource.PhoneOther
                  , myTarget.SSCreatedBy = mySource.SSCreatedBy
                  , myTarget.SSUpdatedBy = mySource.SSUpdatedBy
                  , myTarget.SSCreatedDate = mySource.SSCreatedDate
                  , myTarget.SSUpdatedDate = mySource.SSUpdatedDate
                  , myTarget.UpdatedBy = 'CI'
                  , myTarget.UpdatedDate = @RunTime;

/***EmailPrimary***/
        MERGE dbo.DimCustomer AS myTarget
        USING
            (
              SELECT    *
              FROM      ods.vw_Fanatics_LoadDimCustomer
            ) AS mySource
        ON myTarget.SourceDB = mySource.SourceDB
            AND myTarget.SourceSystem = mySource.SourceSystem
            AND myTarget.SSID = mySource.SSID
        WHEN MATCHED AND ISNULL(mySource.EmailPrimaryDirtyHash, -1) <> ISNULL(myTarget.EmailPrimaryDirtyHash,
                                                              -1) THEN
            UPDATE SET
                    myTarget.SourceDB = mySource.SourceDB
                  , myTarget.SourceSystem = mySource.SourceSystem
                  , myTarget.SSID = mySource.SSID
                  , myTarget.EmailPrimaryDirtyHash = mySource.EmailPrimaryDirtyHash
                  , myTarget.EmailPrimaryIsCleanStatus = 'Dirty'
                  , myTarget.EmailPrimary = mySource.EmailPrimary
                  , myTarget.SSCreatedBy = mySource.SSCreatedBy
                  , myTarget.SSUpdatedBy = mySource.SSUpdatedBy
                  , myTarget.SSCreatedDate = mySource.SSCreatedDate
                  , myTarget.SSUpdatedDate = mySource.SSUpdatedDate
                  , myTarget.UpdatedBy = 'CI'
                  , myTarget.UpdatedDate = @RunTime;

/***EmailOne***/
        MERGE dbo.DimCustomer AS myTarget
        USING
            (
              SELECT    *
              FROM      ods.vw_Fanatics_LoadDimCustomer
            ) AS mySource
        ON myTarget.SourceDB = mySource.SourceDB
            AND myTarget.SourceSystem = mySource.SourceSystem
            AND myTarget.SSID = mySource.SSID
        WHEN MATCHED AND ISNULL(mySource.EmailOneDirtyHash, -1) <> ISNULL(myTarget.EmailOneDirtyHash,
                                                              -1) THEN
            UPDATE SET
                    myTarget.SourceDB = mySource.SourceDB
                  , myTarget.SourceSystem = mySource.SourceSystem
                  , myTarget.SSID = mySource.SSID
                  , myTarget.EmailOneDirtyHash = mySource.EmailOneDirtyHash
                  , myTarget.EmailOneIsCleanStatus = 'Dirty'
                  , myTarget.EmailOne = mySource.EmailOne
                  , myTarget.SSCreatedBy = mySource.SSCreatedBy
                  , myTarget.SSUpdatedBy = mySource.SSUpdatedBy
                  , myTarget.SSCreatedDate = mySource.SSCreatedDate
                  , myTarget.SSUpdatedDate = mySource.SSUpdatedDate
                  , myTarget.UpdatedBy = 'CI'
                  , myTarget.UpdatedDate = @RunTime;

/***EmailTwo***/
        MERGE dbo.DimCustomer AS myTarget
        USING
            (
              SELECT    *
              FROM      ods.vw_Fanatics_LoadDimCustomer
            ) AS mySource
        ON myTarget.SourceDB = mySource.SourceDB
            AND myTarget.SourceSystem = mySource.SourceSystem
            AND myTarget.SSID = mySource.SSID
        WHEN MATCHED AND ISNULL(mySource.EmailTwoDirtyHash, -1) <> ISNULL(myTarget.EmailTwoDirtyHash,
                                                              -1) THEN
            UPDATE SET
                    myTarget.SourceDB = mySource.SourceDB
                  , myTarget.SourceSystem = mySource.SourceSystem
                  , myTarget.SSID = mySource.SSID
                  , myTarget.EmailTwoDirtyHash = mySource.EmailTwoDirtyHash
                  , myTarget.EmailTwoIsCleanStatus = 'Dirty'
                  , myTarget.EmailTwo = mySource.EmailTwo
                  , myTarget.SSCreatedBy = mySource.SSCreatedBy
                  , myTarget.SSUpdatedBy = mySource.SSUpdatedBy
                  , myTarget.SSCreatedDate = mySource.SSCreatedDate
                  , myTarget.SSUpdatedDate = mySource.SSUpdatedDate
                  , myTarget.UpdatedBy = 'CI'
                  , myTarget.UpdatedDate = @RunTime;

        PRINT 'aa';
/***Standard and Extended Attributes***/
        MERGE dbo.DimCustomer AS myTarget
        USING
            (
              SELECT    *
              FROM      ods.vw_Fanatics_LoadDimCustomer
            ) AS mySource
        ON myTarget.SourceDB = mySource.SourceDB
            AND myTarget.SourceSystem = mySource.SourceSystem
            AND myTarget.SSID = mySource.SSID
        WHEN MATCHED --AND 
            THEN
            UPDATE SET
                    myTarget.CustomerType = mySource.CustomerType
                  , myTarget.CustomerStatus = mySource.CustomerStatus
                  , myTarget.AccountType = mySource.AccountType
                  , myTarget.AccountRep = mySource.AccountRep
                  , myTarget.CompanyName = mySource.CompanyName
	--, myTarget.SalutationName = mySource.SalutationName
                  , myTarget.DonorMailName = mySource.DonorMailName
                  , myTarget.DonorFormalName = mySource.DonorFormalName
                  --, myTarget.Birthday = mySource.Birthday
                  , myTarget.Gender = mySource.Gender
                  , myTarget.AccountId = mySource.AccountId
                  , myTarget.MergedRecordFlag = mySource.MergedRecordFlag
                  , myTarget.MergedIntoSSID = mySource.MergedIntoSSID
                  , myTarget.IsBusiness = mySource.IsBusiness
                  , myTarget.ExtAttribute1 = mySource.ExtAttribute1
                  , myTarget.ExtAttribute2 = mySource.ExtAttribute2
                  , myTarget.ExtAttribute3 = mySource.ExtAttribute3
                  , myTarget.ExtAttribute4 = mySource.ExtAttribute4
                  , myTarget.ExtAttribute5 = mySource.ExtAttribute5
                  , myTarget.ExtAttribute6 = mySource.ExtAttribute6
                  , myTarget.ExtAttribute7 = mySource.ExtAttribute7
                  , myTarget.ExtAttribute8 = mySource.ExtAttribute8
                  , myTarget.ExtAttribute9 = mySource.ExtAttribute9
                  , myTarget.ExtAttribute10 = mySource.ExtAttribute10
                  , myTarget.ExtAttribute11 = mySource.ExtAttribute11
                  , myTarget.ExtAttribute12 = mySource.ExtAttribute12
                  , myTarget.ExtAttribute13 = mySource.ExtAttribute13
                  , myTarget.ExtAttribute14 = mySource.ExtAttribute14
                  , myTarget.ExtAttribute15 = mySource.ExtAttribute15
                  , myTarget.ExtAttribute16 = mySource.ExtAttribute16
                  , myTarget.ExtAttribute17 = mySource.ExtAttribute17
                  , myTarget.ExtAttribute18 = mySource.ExtAttribute18
                  , myTarget.ExtAttribute19 = mySource.ExtAttribute19
                  , myTarget.ExtAttribute20 = mySource.ExtAttribute20
                  , myTarget.ExtAttribute21 = mySource.ExtAttribute21
                  , myTarget.ExtAttribute22 = mySource.ExtAttribute22
                  , myTarget.ExtAttribute23 = mySource.ExtAttribute23
                  , myTarget.ExtAttribute24 = mySource.ExtAttribute24
                  , myTarget.ExtAttribute25 = mySource.ExtAttribute25
                  , myTarget.ExtAttribute26 = mySource.ExtAttribute26
                  , myTarget.ExtAttribute27 = mySource.ExtAttribute27
                  , myTarget.ExtAttribute28 = mySource.ExtAttribute28
                  , myTarget.ExtAttribute29 = mySource.ExtAttribute29
                  , myTarget.ExtAttribute30 = mySource.ExtAttribute30
                  , myTarget.SSCreatedBy = mySource.SSCreatedBy
                  , myTarget.SSUpdatedBy = mySource.SSUpdatedBy
                  , myTarget.SSCreatedDate = mySource.SSCreatedDate
                  , myTarget.SSUpdatedDate = mySource.SSUpdatedDate
                  , myTarget.UpdatedBy = 'CI'
                  , myTarget.UpdatedDate = @RunTime;

    END;





GO
