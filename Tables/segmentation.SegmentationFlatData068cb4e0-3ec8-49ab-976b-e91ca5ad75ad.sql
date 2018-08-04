CREATE TABLE [segmentation].[SegmentationFlatData068cb4e0-3ec8-49ab-976b-e91ca5ad75ad]
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
ALTER TABLE [segmentation].[SegmentationFlatData068cb4e0-3ec8-49ab-976b-e91ca5ad75ad] ADD CONSTRAINT [pk_SegmentationFlatData068cb4e0-3ec8-49ab-976b-e91ca5ad75ad] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatData068cb4e0-3ec8-49ab-976b-e91ca5ad75ad] ON [segmentation].[SegmentationFlatData068cb4e0-3ec8-49ab-976b-e91ca5ad75ad] ([_rn])
GO
