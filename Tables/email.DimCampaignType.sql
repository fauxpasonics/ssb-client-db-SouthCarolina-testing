CREATE TABLE [email].[DimCampaignType]
(
[DimCampaignTypeId] [int] NOT NULL IDENTITY(-2, 1),
[CampaignType] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__DimCampai__Creat__69F2979F] DEFAULT (user_name()),
[CreatedDate] [datetime] NULL CONSTRAINT [DF__DimCampai__Creat__6AE6BBD8] DEFAULT (getdate()),
[UpdatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__DimCampai__Updat__6BDAE011] DEFAULT (user_name()),
[UpdatedDate] [datetime] NULL CONSTRAINT [DF__DimCampai__Updat__6CCF044A] DEFAULT (getdate())
)
GO
ALTER TABLE [email].[DimCampaignType] ADD CONSTRAINT [PK__DimCampa__7EB1CFE5DFAD60E6] PRIMARY KEY CLUSTERED  ([DimCampaignTypeId])
GO
