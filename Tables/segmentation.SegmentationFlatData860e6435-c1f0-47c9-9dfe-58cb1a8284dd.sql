CREATE TABLE [segmentation].[SegmentationFlatData860e6435-c1f0-47c9-9dfe-58cb1a8284dd]
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
ALTER TABLE [segmentation].[SegmentationFlatData860e6435-c1f0-47c9-9dfe-58cb1a8284dd] ADD CONSTRAINT [pk_SegmentationFlatData860e6435-c1f0-47c9-9dfe-58cb1a8284dd] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatData860e6435-c1f0-47c9-9dfe-58cb1a8284dd] ON [segmentation].[SegmentationFlatData860e6435-c1f0-47c9-9dfe-58cb1a8284dd] ([_rn])
GO
