CREATE TABLE [segmentation].[SegmentationFlatData75787595-51a2-4423-b94a-40d7518a8a4d]
(
[id] [uniqueidentifier] NOT NULL,
[DocumentType] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[_rn] [bigint] NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmmaMemberID] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmmaMemberType] [nvarchar] (1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmmaLastSyncedDate] [datetime] NULL,
[EmmaBounced] [bit] NULL,
[EmmaEmailName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmmaEmailOpened] [nvarchar] (1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmmaGroupName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmmaMailingName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmmaEmailSubject] [nvarchar] (120) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CountClicks] [float] NULL,
[CountOpens] [float] NULL,
[CountShares] [float] NULL,
[CountForwards] [float] NULL
)
GO
ALTER TABLE [segmentation].[SegmentationFlatData75787595-51a2-4423-b94a-40d7518a8a4d] ADD CONSTRAINT [pk_SegmentationFlatData75787595-51a2-4423-b94a-40d7518a8a4d] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatData75787595-51a2-4423-b94a-40d7518a8a4d] ON [segmentation].[SegmentationFlatData75787595-51a2-4423-b94a-40d7518a8a4d] ([_rn])
GO
