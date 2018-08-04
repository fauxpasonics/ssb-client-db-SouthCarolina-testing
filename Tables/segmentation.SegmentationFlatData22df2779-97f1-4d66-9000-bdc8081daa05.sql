CREATE TABLE [segmentation].[SegmentationFlatData22df2779-97f1-4d66-9000-bdc8081daa05]
(
[id] [uniqueidentifier] NOT NULL,
[DocumentType] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[_rn] [bigint] NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerSourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
ALTER TABLE [segmentation].[SegmentationFlatData22df2779-97f1-4d66-9000-bdc8081daa05] ADD CONSTRAINT [pk_SegmentationFlatData22df2779-97f1-4d66-9000-bdc8081daa05] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatData22df2779-97f1-4d66-9000-bdc8081daa05] ON [segmentation].[SegmentationFlatData22df2779-97f1-4d66-9000-bdc8081daa05] ([_rn])
GO
