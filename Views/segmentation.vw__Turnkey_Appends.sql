SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [segmentation].[vw__Turnkey_Appends]

AS
(


SELECT DISTINCT c.* from dbo.vwDimCustomer_ModAcctId a
INNER JOIN (SELECT
		b.SSB_CRMSYSTEM_CONTACT_ID
                      --, Age00to02_Female 
                      --, Age00to02_Male 
                      --, Age00to02_UnknownGender 
                      --, Age03to05_Female 
                      --, Age03to05_Male 
                      --, Age03to05_UnknownGender 
                      --, Age06to10_Female
                      --, Age06to10_Male 
                      --, Age06to10_UnknownGender 
                      --, Age11to15_Female
                      --, Age11to15_Male 
                      --, Age11to15_UnknownGender 
                      --, Age16to17_Female 
                      --, Age16to17_Male 
                      --, Age16to17_UnknownGender 
                      --, AgeInTwoYearIncrements_1stIndividual 
                      --, AgeInTwoYearIncrements_2ndIndividual
                      , AgeInTwoYearIncrements_InputIndividual 
                      --, ApartmentNumber 
                      --, Apparel_FemaleApparel_MOBs 
                      --, Apparel_Jewelry_MOBs 
                      --, Apparel_MaleApparel_MOBs 
                      --, Apparel_PlusSizeWomensClothing_MOBs 
                      --, Apparel_TeenFashion_MOBs 
                      --, Apparel_UnknownType
                      --, ArtandAntique_MOBs 
                      --, ArtsandCrafts_MOBs 
                      --, AutoSupplies_MOBs 
                      --, BankCardHolder 
                      --, Bank_FinancialServicesBanking 
                      --, BaseRecordVerificationDate 
                      --, Beauty_MOBs 
                      --, Book_MOBs
                      , BusinessOwner 
                      --, ChildrensMerchandise_MOBs 
                      --, Collectible_MOBs 
                      , Collectibles_SportsMemorabilia 
                      --, ComputerSoftware_MOBs 
                      --, CreditCardHolder_UnknownType 
                      , DiscretionaryIncomeIndex 
                      , DwellingType 
                      --, Education_1stIndividual 
                      --, Education_2ndIndividual 
                      , Education_InputIndividual 
                      --, Electronic_MOBs 
                      --, Equestrian_MOBs 
                      , Females_18to24 
                      , Females_25to34 
                      , Females_35to44 
                      , Females_45to54 
                      , Females_55to64
                      , Females_65to74 
                      , Females_75plus 
                      --, FinanceCompany_FinancialServicesInstallCredit 
                      --, FirstName_1stIndividual
                      --, FirstName_2ndIndividual
                      --, Food_MOBs 
                      --, GasDepartmentRetailCardHolder 
                      --, Gender_1stIndividual 
                      --, Gender_2ndIndividual
                      , Gender_InputIndividual 
                      --, GeneralGiftsandMerchandise_MOBs 
                      --, Gift_MOBs 
                      --, Health_MOBs 
                      --, HomeAssessedValue_Ranges 
                      --, HomeFurnishingandDecorating_MOBs 
                      , HomeMarketValue 
                      , HomeOwnerorRenter 
                      --, HomePhone
                      , HomePropertyType_Detail 
                      , HomeSquareFootage_Actual 
                      , HomeYearBuilt_Actual 
                      , Income_EstimatedHousehold
                      --, InfoBasePositiveMatchIndicator 
                      , Investing_Active 
                      , LengthofResidence 
                      , MailOrder_Buyer 
                      , MailOrder_Donor 
                      , MailOrder_Responder 
                      , Males_18to24 
                      , Males_25to34 
                      , Males_35to44 
                      , Males_45to54 
                      , Males_55to64 
                      , Males_65to74 
                      , Males_75plus 
                      , MaritalStatusinHousehold 
                      --, Merchandise_HighTicketMerchandise_MOBs 
                      --, Merchandise_LowTicketMerchandise_MOBs 
                      --, MiddleInitial_1stIndividual 
                      --, MiddleInitial_2ndIndividual
                      --, Miscellaneous_FinancialServicesInsurance 
                      --, Miscellaneous_Grocery
                      --, Miscellaneous_Miscellaneous 
                      --, Miscellaneous_TVMailOrderPurchases 
                      , MotorcycleOwner 
                      --, Music_MOBs 
                      , NetWorthGold 
                      --, NumberofAdults 
                      --, NumberofSources 
                      --, Occupation_1stIndividual 
                      --, Occupation_2ndIndividual 
                      , OccupationDetail_InputIndividual 
                      , Occupation_InputIndividual 
                      --, OilCompany_OilCompany 
                      , OnlinePurchasingIndicator 
                      --, OutdoorGardening_MOBs 
                      --, OutdoorHuntingandFishing_MOBs 
                      --, OverallMatchIndicator 
                      , PersonicxClusterCode 
                      , PersonicxCluster 
                      , PersonicxDigitalClusterCode 
                      , PersonicxDigitalCluster 
                      --, PetSupplies_MOBs 
                      --, PrecisionLevel
                      , PremiumCardHolder 
                      , PresenceofChildren
                      --, Purchase_0to3Months 
                      --, Purchase_10to12Months 
                      --, Purchase_13to18Months 
                      --, Purchase_19to24Months 
                      --, Purchase_24PlusMonths 
                      --, Purchase_4to6Months 
                      --, Purchase_7to9Months 
                      , RaceCode 
                      , RetailActivity_DateofLast 
                      , RetailPurchases_MostFrequentCategory 
                      , RVOwner 
                      , SpectatorSports_AutoMotorcycleRacing 
                      , SpectatorSports_Baseball 
                      , SpectatorSports_Basketball 
                      , SpectatorSports_Football 
                      , SpectatorSports_Hockey 
                      , SpectatorSports_Soccer 
                      , SpectatorSports_Tennis 
                      , Sports_GolfMOBs 
                      , SportsAndLeisure_SC 
                      , Sports_MOBs 
                      , StandardRetail_CatalogShowroomRetailBuyers 
                      , StandardRetail_HighVolumeLowEndDepartmentStoreBuyers 
                      , StandardRetail_MainStreetRetail 
                      , StandardRetail_MembershipWarehouse 
                      , StandardRetail_StandardRetail 
                      , StandardSpecialty_ComputerElectronicsBuyers 
                      , StandardSpecialty_FurnitureBuyers 
                      , StandardSpecialty_HomeImprovement 
                      , StandardSpecialty_HomeOfficeSupplyPurchases 
                      , StandardSpecialty_Specialty 
                      , StandardSpecialty_SpecialtyApparel 
                      , StandardSpecialty_SportingGoods 
                      --, SuppressionMailDMA 
                      , TravelandEntertainmentCardHolder 
                      , Travel_MOBs 
                      , TruckOwner 
                      --, UnknownGender_18to24 
                      --, UnknownGender_25to34 
                      --, UnknownGender_35to44  
                      --, UnknownGender_45to54
                      --, UnknownGender_55to64 
                      --, UnknownGender_65to74
                      --, UnknownGender_75plus 
                      , UpscaleCardHolder 
                      , UpscaleRetail_HighEndRetailBuyersUpscaleRetail 
                      , UpscaleSpecialty_TravelPersonalServices 
                      , Vehicle_DominantLifestyleIndicator 
                      , Vehicle_KnownOwnedNumber 
                      , Vehicle_NewCarBuyer 
                      , Vehicle_NewUsedIndicator_1stVehicle 
                      , Vehicle_NewUsedIndicator_2ndVehicle 
                      --, VideoDVD_MOBs 
                      , WorkingWoman 
					  ,[TurnkeyStandardBundleDate]
					  ,ROW_NUMBER() OVER (PARTITION BY b.SSB_CRMSYSTEM_CONTACT_ID ORDER BY t.TurnkeyStandardBundleDate DESC) RN
	
	FROM ods.Turnkey_Acxiom t JOIN dbo.vwDimCustomer_ModAcctId b ON b.SSID = t.ProspectId AND b.SourceSystem = 'SouthCarolina_Turnkey') c
		ON a.SSB_CRMSYSTEM_CONTACT_ID = c.SSB_CRMSYSTEM_CONTACT_ID AND c.RN = 1 AND a.SourceSystem = 'SouthCarolina_Turnkey'

)





GO
