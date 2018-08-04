CREATE TABLE [segmentation].[SegmentationFlatDatacde1cd4d-5628-4528-a0f4-b12b1010f197]
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
ALTER TABLE [segmentation].[SegmentationFlatDatacde1cd4d-5628-4528-a0f4-b12b1010f197] ADD CONSTRAINT [pk_SegmentationFlatDatacde1cd4d-5628-4528-a0f4-b12b1010f197] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatDatacde1cd4d-5628-4528-a0f4-b12b1010f197] ON [segmentation].[SegmentationFlatDatacde1cd4d-5628-4528-a0f4-b12b1010f197] ([_rn])
GO
