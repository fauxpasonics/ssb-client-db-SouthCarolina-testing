CREATE TABLE [segmentation].[SegmentationFlatData918291c4-c1b3-4af4-b31a-ba7d061d6469]
(
[id] [uniqueidentifier] NULL,
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