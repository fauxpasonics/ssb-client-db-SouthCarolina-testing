CREATE TABLE [segmentation].[SegmentationFlatData0ae88a18-4469-4a95-9c8a-acc454a4fe68]
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
ALTER TABLE [segmentation].[SegmentationFlatData0ae88a18-4469-4a95-9c8a-acc454a4fe68] ADD CONSTRAINT [pk_SegmentationFlatData0ae88a18-4469-4a95-9c8a-acc454a4fe68] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatData0ae88a18-4469-4a95-9c8a-acc454a4fe68] ON [segmentation].[SegmentationFlatData0ae88a18-4469-4a95-9c8a-acc454a4fe68] ([_rn])
GO
