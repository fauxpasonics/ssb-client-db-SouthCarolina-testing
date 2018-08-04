CREATE TABLE [segmentation].[SegmentationFlatDatab68cd2a5-bd28-4645-87ba-093a39a2eff1]
(
[id] [uniqueidentifier] NOT NULL,
[DocumentType] [varchar] (23) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[_rn] [bigint] NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[R_Archtics_Acct_Id] [int] NULL,
[R_Activity] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[R_Activity_Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[R_Transaction_Date] [date] NULL,
[R_Season_Year] [int] NULL,
[R_Event_Code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[R_Event_Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[R_Event_Time] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[R_Event_Date] [datetime] NULL,
[R_Section_Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[R_Row_Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[R_First_Seat] [int] NULL,
[R_Qty_Seat] [int] NULL,
[R_Orig_purchase_price] [numeric] (29, 2) NULL,
[R_TE_Purchase_Price] [numeric] (18, 0) NULL,
[R_TE_Price_Difference] [numeric] (30, 0) NULL
)
GO
ALTER TABLE [segmentation].[SegmentationFlatDatab68cd2a5-bd28-4645-87ba-093a39a2eff1] ADD CONSTRAINT [pk_SegmentationFlatDatab68cd2a5-bd28-4645-87ba-093a39a2eff1] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatDatab68cd2a5-bd28-4645-87ba-093a39a2eff1] ON [segmentation].[SegmentationFlatDatab68cd2a5-bd28-4645-87ba-093a39a2eff1] ([_rn])
GO
