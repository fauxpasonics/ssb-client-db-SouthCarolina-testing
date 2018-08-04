CREATE TABLE [segmentation].[SegmentationFlatDatafb09f115-be27-4d69-9739-80b7cace2767]
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
ALTER TABLE [segmentation].[SegmentationFlatDatafb09f115-be27-4d69-9739-80b7cace2767] ADD CONSTRAINT [pk_SegmentationFlatDatafb09f115-be27-4d69-9739-80b7cace2767] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatDatafb09f115-be27-4d69-9739-80b7cace2767] ON [segmentation].[SegmentationFlatDatafb09f115-be27-4d69-9739-80b7cace2767] ([_rn])
GO
