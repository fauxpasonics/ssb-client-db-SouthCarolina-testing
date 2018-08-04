CREATE TABLE [dbo].[DimSalesCode]
(
[DimSalesCodeId] [int] NOT NULL IDENTITY(1, 1),
[SalesCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SalesCodeName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SalesCodeDesc] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SalesCodeClass] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsHost] [bit] NULL,
[SalesCodeStartDate] [date] NULL,
[SalesCodeEndDate] [date] NULL,
[SalesCodeStatus] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSCreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSUpdatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSCreatedDate] [datetime] NULL,
[SSUpdatedDate] [datetime] NULL,
[SSID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSID_sell_location_id] [int] NULL,
[SourceSystem] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeltaHashKey] [binary] (32) NULL,
[CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__DimSalesC__Creat__29221CFB] DEFAULT (getdate()),
[UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF__DimSalesC__Updat__2A164134] DEFAULT (getdate()),
[IsDeleted] [bit] NOT NULL CONSTRAINT [DF__DimSalesC__IsDel__2B0A656D] DEFAULT ((0)),
[DeleteDate] [datetime] NULL
)
GO
ALTER TABLE [dbo].[DimSalesCode] ADD CONSTRAINT [PK_DimSalesCode] PRIMARY KEY CLUSTERED  ([DimSalesCodeId])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_LoadKey] ON [dbo].[DimSalesCode] ([SourceSystem], [SSID_sell_location_id])
GO
