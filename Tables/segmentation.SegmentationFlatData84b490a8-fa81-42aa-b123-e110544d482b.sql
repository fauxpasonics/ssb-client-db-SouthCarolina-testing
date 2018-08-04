CREATE TABLE [segmentation].[SegmentationFlatData84b490a8-fa81-42aa-b123-e110544d482b]
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
ALTER TABLE [segmentation].[SegmentationFlatData84b490a8-fa81-42aa-b123-e110544d482b] ADD CONSTRAINT [pk_SegmentationFlatData84b490a8-fa81-42aa-b123-e110544d482b] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatData84b490a8-fa81-42aa-b123-e110544d482b] ON [segmentation].[SegmentationFlatData84b490a8-fa81-42aa-b123-e110544d482b] ([_rn])
GO
