CREATE TABLE [segmentation].[SegmentationFlatDatad40d0fa4-cb75-425c-99dd-d16173710190]
(
[id] [uniqueidentifier] NULL,
[DocumentType] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
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
CREATE CLUSTERED COLUMNSTORE INDEX [ccix_SegmentationFlatDatad40d0fa4-cb75-425c-99dd-d16173710190] ON [segmentation].[SegmentationFlatDatad40d0fa4-cb75-425c-99dd-d16173710190]
GO
