CREATE TABLE [segmentation].[SegmentationFlatData2f48b811-e515-4522-a646-d623dc1dbc61]
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
ALTER TABLE [segmentation].[SegmentationFlatData2f48b811-e515-4522-a646-d623dc1dbc61] ADD CONSTRAINT [pk_SegmentationFlatData2f48b811-e515-4522-a646-d623dc1dbc61] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatData2f48b811-e515-4522-a646-d623dc1dbc61] ON [segmentation].[SegmentationFlatData2f48b811-e515-4522-a646-d623dc1dbc61] ([_rn])
GO
