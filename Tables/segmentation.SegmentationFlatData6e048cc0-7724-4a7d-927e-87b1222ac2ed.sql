CREATE TABLE [segmentation].[SegmentationFlatData6e048cc0-7724-4a7d-927e-87b1222ac2ed]
(
[id] [uniqueidentifier] NOT NULL,
[DocumentType] [varchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[_rn] [bigint] NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BasketballPriority] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GroupPriority] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FootballPriority] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FootballGroupPriority] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [segmentation].[SegmentationFlatData6e048cc0-7724-4a7d-927e-87b1222ac2ed] ADD CONSTRAINT [pk_SegmentationFlatData6e048cc0-7724-4a7d-927e-87b1222ac2ed] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatData6e048cc0-7724-4a7d-927e-87b1222ac2ed] ON [segmentation].[SegmentationFlatData6e048cc0-7724-4a7d-927e-87b1222ac2ed] ([_rn])
GO
