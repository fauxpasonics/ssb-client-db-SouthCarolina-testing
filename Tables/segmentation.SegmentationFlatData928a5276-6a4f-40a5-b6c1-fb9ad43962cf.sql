CREATE TABLE [segmentation].[SegmentationFlatData928a5276-6a4f-40a5-b6c1-fb9ad43962cf]
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
ALTER TABLE [segmentation].[SegmentationFlatData928a5276-6a4f-40a5-b6c1-fb9ad43962cf] ADD CONSTRAINT [pk_SegmentationFlatData928a5276-6a4f-40a5-b6c1-fb9ad43962cf] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatData928a5276-6a4f-40a5-b6c1-fb9ad43962cf] ON [segmentation].[SegmentationFlatData928a5276-6a4f-40a5-b6c1-fb9ad43962cf] ([_rn])
GO
