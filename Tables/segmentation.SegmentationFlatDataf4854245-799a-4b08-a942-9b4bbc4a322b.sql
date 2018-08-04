CREATE TABLE [segmentation].[SegmentationFlatDataf4854245-799a-4b08-a942-9b4bbc4a322b]
(
[id] [uniqueidentifier] NOT NULL,
[DocumentType] [varchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[_rn] [bigint] NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BasketballPriority] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GroupPriority] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FootballPriority] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FootballGroupPriority] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [segmentation].[SegmentationFlatDataf4854245-799a-4b08-a942-9b4bbc4a322b] ADD CONSTRAINT [pk_SegmentationFlatDataf4854245-799a-4b08-a942-9b4bbc4a322b] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatDataf4854245-799a-4b08-a942-9b4bbc4a322b] ON [segmentation].[SegmentationFlatDataf4854245-799a-4b08-a942-9b4bbc4a322b] ([_rn])
GO
