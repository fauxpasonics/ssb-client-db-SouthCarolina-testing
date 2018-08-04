CREATE TABLE [segmentation].[SegmentationFlatDatafb28a886-fe1f-4d64-8f61-18b88cc4be00]
(
[id] [uniqueidentifier] NOT NULL,
[DocumentType] [varchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[_rn] [bigint] NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SFDC_ContactID] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SFDC_AccountID] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NULL,
[CreatedById] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedByName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastModifiedDate] [datetime] NULL,
[LastModifiedById] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OwnerId] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OwnerName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastActivityDate] [date] NULL,
[DaysSinceLastActivity] [int] NULL,
[HasOpenOpportunity] [datetime] NULL,
[LastOpportunityCreatedDate] [datetime] NULL,
[LastOpportunityOwnerName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastOpportunityLastModifiedDate] [datetime] NULL,
[LastOpportunityClosedWonDate] [datetime] NULL,
[LastOpportunityClosedLostReason] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastTicketPurchaseDate] [date] NULL,
[LastDonationDate] [date] NULL,
[DonorWarningFlag] [bit] NULL,
[TotalPriorityPoints] [float] NULL,
[FootballSTH] [bit] NULL,
[FootballRookie] [bit] NULL,
[FootballPartial] [bit] NULL,
[MBBSTH] [bit] NULL,
[MBBRookie] [bit] NULL,
[MBBPartial] [bit] NULL,
[CY_DonationLevel] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CY_DonationAmount] [float] NULL,
[CY_DonationUpsell] [float] NULL,
[CorporateBuyerFlag] [bit] NULL,
[CompanyName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CLA_GroupBuyer] [bit] NULL,
[CLA_PremiumBuyer] [bit] NULL,
[CLA_TotalSpend] [float] NULL
)
GO
ALTER TABLE [segmentation].[SegmentationFlatDatafb28a886-fe1f-4d64-8f61-18b88cc4be00] ADD CONSTRAINT [pk_SegmentationFlatDatafb28a886-fe1f-4d64-8f61-18b88cc4be00] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatDatafb28a886-fe1f-4d64-8f61-18b88cc4be00] ON [segmentation].[SegmentationFlatDatafb28a886-fe1f-4d64-8f61-18b88cc4be00] ([_rn])
GO
