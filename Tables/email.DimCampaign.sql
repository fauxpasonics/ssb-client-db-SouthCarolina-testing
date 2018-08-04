CREATE TABLE [email].[DimCampaign]
(
[DimCampaignId] [int] NOT NULL IDENTITY(-2, 1),
[DimCampaignTypeId] [int] NULL,
[DimChannelId] [int] NULL,
[SourceSystemID] [int] NULL,
[Src_CampaignID] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Subject] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FromEmail] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FromName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[GoalDescription] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__DimCampai__Creat__0C47AFA3] DEFAULT (user_name()),
[CreatedDate] [datetime] NULL CONSTRAINT [DF__DimCampai__Creat__0D3BD3DC] DEFAULT (getdate()),
[UpdatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__DimCampai__Updat__0E2FF815] DEFAULT (user_name()),
[UpdatedDate] [datetime] NULL CONSTRAINT [DF__DimCampai__Updat__0F241C4E] DEFAULT (getdate())
)
GO
ALTER TABLE [email].[DimCampaign] ADD CONSTRAINT [PK__DimCampa__2C52FBADDEF308C7] PRIMARY KEY CLUSTERED  ([DimCampaignId])
GO
ALTER TABLE [email].[DimCampaign] ADD CONSTRAINT [FK__DimCampai__DimCa__110C64C0] FOREIGN KEY ([DimCampaignTypeId]) REFERENCES [email].[DimCampaignType] ([DimCampaignTypeId])
GO
ALTER TABLE [email].[DimCampaign] ADD CONSTRAINT [FK__DimCampai__DimCh__120088F9] FOREIGN KEY ([DimChannelId]) REFERENCES [email].[DimChannel] ([DimChannelId])
GO
ALTER TABLE [email].[DimCampaign] ADD CONSTRAINT [FK__DimCampai__Sourc__12F4AD32] FOREIGN KEY ([SourceSystemID]) REFERENCES [mdm].[SourceSystems] ([SourceSystemID])
GO
