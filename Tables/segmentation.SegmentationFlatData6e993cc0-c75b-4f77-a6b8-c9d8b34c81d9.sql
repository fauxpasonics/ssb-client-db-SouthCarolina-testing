CREATE TABLE [segmentation].[SegmentationFlatData6e993cc0-c75b-4f77-a6b8-c9d8b34c81d9]
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
CREATE CLUSTERED COLUMNSTORE INDEX [ccix_SegmentationFlatData6e993cc0-c75b-4f77-a6b8-c9d8b34c81d9] ON [segmentation].[SegmentationFlatData6e993cc0-c75b-4f77-a6b8-c9d8b34c81d9]
GO
