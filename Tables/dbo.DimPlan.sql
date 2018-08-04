CREATE TABLE [dbo].[DimPlan]
(
[DimPlanId] [int] NOT NULL IDENTITY(1, 1),
[DimSeasonId] [int] NULL,
[PlanCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PlanName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PlanDesc] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PlanClass] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PlanFse] [decimal] (3, 2) NULL,
[PlanType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PlanEventCnt] [int] NULL,
[PlanStartDate] [date] NULL,
[PlanEndDate] [date] NULL,
[PlanStatus] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSCreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSUpdatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSCreatedDate] [datetime] NULL,
[SSUpdatedDate] [datetime] NULL,
[SSID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSID_event_id] [int] NULL,
[SourceSystem] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeltaHashKey] [binary] (32) NULL,
[CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__DimPlan__Created__31B762FC] DEFAULT (getdate()),
[UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF__DimPlan__Updated__32AB8735] DEFAULT (getdate()),
[IsDeleted] [bit] NOT NULL CONSTRAINT [DF__DimPlan__IsDelet__339FAB6E] DEFAULT ((0)),
[DeleteDate] [datetime] NULL,
[FullSeasonEventCnt] [int] NULL
)
GO
ALTER TABLE [dbo].[DimPlan] ADD CONSTRAINT [PK_DimPlan] PRIMARY KEY CLUSTERED  ([DimPlanId])
GO
CREATE NONCLUSTERED INDEX [IDX_DimSeasonId] ON [dbo].[DimPlan] ([DimSeasonId])
GO
CREATE NONCLUSTERED INDEX [IDX_PlanCode] ON [dbo].[DimPlan] ([PlanCode])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_LoadKey] ON [dbo].[DimPlan] ([SourceSystem], [SSID_event_id])
GO
