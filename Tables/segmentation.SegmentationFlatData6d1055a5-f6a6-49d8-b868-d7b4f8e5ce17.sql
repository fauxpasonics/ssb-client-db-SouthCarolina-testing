CREATE TABLE [segmentation].[SegmentationFlatData6d1055a5-f6a6-49d8-b868-d7b4f8e5ce17]
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
ALTER TABLE [segmentation].[SegmentationFlatData6d1055a5-f6a6-49d8-b868-d7b4f8e5ce17] ADD CONSTRAINT [pk_SegmentationFlatData6d1055a5-f6a6-49d8-b868-d7b4f8e5ce17] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatData6d1055a5-f6a6-49d8-b868-d7b4f8e5ce17] ON [segmentation].[SegmentationFlatData6d1055a5-f6a6-49d8-b868-d7b4f8e5ce17] ([_rn])
GO
