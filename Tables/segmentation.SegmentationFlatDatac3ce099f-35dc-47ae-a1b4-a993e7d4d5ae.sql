CREATE TABLE [segmentation].[SegmentationFlatDatac3ce099f-35dc-47ae-a1b4-a993e7d4d5ae]
(
[id] [uniqueidentifier] NOT NULL,
[DocumentType] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[_rn] [bigint] NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SDT_SEASON] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[SDT_SEASON_NAME] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SDT_EVENT] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[SDT_EVENT_NAME] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SDT_LEVEL] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[SDT_SECTION] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[SDT_ROW] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[SDT_SEAT] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SDT_STAT] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SDT_STAT_NAME] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SDT_ITEM] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SDT_ITEM_NAME] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SDT_PRICE_TYPE] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SDT_PRICE_TYPE_NAME] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SDT_PRICE_TYPE_CLASS] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SDT_PL] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SDT_PL_NAME] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SDT_PREV_STATUS] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SDT_PREV_STATUS_NAME] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SDT_AISLE] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SDT_ORDER_DATE] [datetime] NOT NULL,
[SDT_ORDER_PRICE] [numeric] (18, 2) NULL,
[SDT_SCAN_DATE] [datetime] NULL,
[SDT_SCAN_TIME] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SDT_SCAN_LOC] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SDT_SCAN_CLUSTER] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SDT_SCAN_GATE] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SDT_SCAN_RESPONSE] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SDT_REDEEMED] [smallint] NULL,
[SDT_ATTENDED] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [segmentation].[SegmentationFlatDatac3ce099f-35dc-47ae-a1b4-a993e7d4d5ae] ADD CONSTRAINT [pk_SegmentationFlatDatac3ce099f-35dc-47ae-a1b4-a993e7d4d5ae] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatDatac3ce099f-35dc-47ae-a1b4-a993e7d4d5ae] ON [segmentation].[SegmentationFlatDatac3ce099f-35dc-47ae-a1b4-a993e7d4d5ae] ([_rn])
GO
