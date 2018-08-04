CREATE TABLE [segmentation].[SegmentationFlatData5e0d0212-cb8a-4b4d-b2bc-b03ec92c5f27]
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
ALTER TABLE [segmentation].[SegmentationFlatData5e0d0212-cb8a-4b4d-b2bc-b03ec92c5f27] ADD CONSTRAINT [pk_SegmentationFlatData5e0d0212-cb8a-4b4d-b2bc-b03ec92c5f27] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatData5e0d0212-cb8a-4b4d-b2bc-b03ec92c5f27] ON [segmentation].[SegmentationFlatData5e0d0212-cb8a-4b4d-b2bc-b03ec92c5f27] ([_rn])
GO
