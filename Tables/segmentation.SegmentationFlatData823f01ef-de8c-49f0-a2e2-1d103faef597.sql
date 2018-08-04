CREATE TABLE [segmentation].[SegmentationFlatData823f01ef-de8c-49f0-a2e2-1d103faef597]
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
ALTER TABLE [segmentation].[SegmentationFlatData823f01ef-de8c-49f0-a2e2-1d103faef597] ADD CONSTRAINT [pk_SegmentationFlatData823f01ef-de8c-49f0-a2e2-1d103faef597] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatData823f01ef-de8c-49f0-a2e2-1d103faef597] ON [segmentation].[SegmentationFlatData823f01ef-de8c-49f0-a2e2-1d103faef597] ([_rn])
GO
