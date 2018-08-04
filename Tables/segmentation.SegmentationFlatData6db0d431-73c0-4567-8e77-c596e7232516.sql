CREATE TABLE [segmentation].[SegmentationFlatData6db0d431-73c0-4567-8e77-c596e7232516]
(
[id] [uniqueidentifier] NOT NULL,
[DocumentType] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[_rn] [bigint] NULL,
[SEASON] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[SEASON_NAME] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUSTOMER] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ITEM] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ITEM_NAME] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[I_PT] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[I_PT_NAME] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[I_PL] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[PL_NAME] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[I_PRICE] [numeric] (18, 2) NULL,
[I_DAMT] [numeric] (18, 2) NULL,
[I_OQTY] [bigint] NULL,
[ORDTOTAL] [numeric] (38, 2) NULL,
[PAIDTOTAL] [numeric] (18, 2) NULL,
[I_DATE] [datetime] NULL
)
GO
ALTER TABLE [segmentation].[SegmentationFlatData6db0d431-73c0-4567-8e77-c596e7232516] ADD CONSTRAINT [pk_SegmentationFlatData6db0d431-73c0-4567-8e77-c596e7232516] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatData6db0d431-73c0-4567-8e77-c596e7232516] ON [segmentation].[SegmentationFlatData6db0d431-73c0-4567-8e77-c596e7232516] ([_rn])
GO
