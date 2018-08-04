CREATE TABLE [segmentation].[SegmentationFlatDatae963e482-fa7b-40f3-85a4-f67e26b0e1db]
(
[id] [uniqueidentifier] NULL,
[DocumentType] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerSourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [ccix_SegmentationFlatDatae963e482-fa7b-40f3-85a4-f67e26b0e1db] ON [segmentation].[SegmentationFlatDatae963e482-fa7b-40f3-85a4-f67e26b0e1db]
GO
