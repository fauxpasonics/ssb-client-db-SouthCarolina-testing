CREATE TABLE [segmentation].[SegmentationFlatDataa548b7cb-0beb-454b-93d8-49539c9145e0]
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
ALTER TABLE [segmentation].[SegmentationFlatDataa548b7cb-0beb-454b-93d8-49539c9145e0] ADD CONSTRAINT [pk_SegmentationFlatDataa548b7cb-0beb-454b-93d8-49539c9145e0] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatDataa548b7cb-0beb-454b-93d8-49539c9145e0] ON [segmentation].[SegmentationFlatDataa548b7cb-0beb-454b-93d8-49539c9145e0] ([_rn])
GO
