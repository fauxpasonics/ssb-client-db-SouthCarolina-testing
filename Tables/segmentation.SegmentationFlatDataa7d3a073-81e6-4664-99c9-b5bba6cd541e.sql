CREATE TABLE [segmentation].[SegmentationFlatDataa7d3a073-81e6-4664-99c9-b5bba6cd541e]
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
ALTER TABLE [segmentation].[SegmentationFlatDataa7d3a073-81e6-4664-99c9-b5bba6cd541e] ADD CONSTRAINT [pk_SegmentationFlatDataa7d3a073-81e6-4664-99c9-b5bba6cd541e] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatDataa7d3a073-81e6-4664-99c9-b5bba6cd541e] ON [segmentation].[SegmentationFlatDataa7d3a073-81e6-4664-99c9-b5bba6cd541e] ([_rn])
GO
