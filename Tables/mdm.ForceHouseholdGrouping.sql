CREATE TABLE [mdm].[ForceHouseholdGrouping]
(
[DimCustomerId] [int] NULL,
[GroupingID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__ForceHous__Creat__05627A8E] DEFAULT (getdate()),
[UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF__ForceHous__Updat__06569EC7] DEFAULT (getdate()),
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ModifiedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriorGrouping] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
GRANT DELETE ON  [mdm].[ForceHouseholdGrouping] TO [db_SSB_IE_Permitted]
GO
GRANT INSERT ON  [mdm].[ForceHouseholdGrouping] TO [db_SSB_IE_Permitted]
GO
GRANT UPDATE ON  [mdm].[ForceHouseholdGrouping] TO [db_SSB_IE_Permitted]
GO
