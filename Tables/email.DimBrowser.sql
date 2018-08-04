CREATE TABLE [email].[DimBrowser]
(
[DimBrowserId] [int] NOT NULL IDENTITY(-2, 1),
[Browser] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__DimBrowse__Creat__5E80E4F3] DEFAULT (user_name()),
[CreatedDate] [datetime] NULL CONSTRAINT [DF__DimBrowse__Creat__5F75092C] DEFAULT (getdate()),
[UpdatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__DimBrowse__Updat__60692D65] DEFAULT (user_name()),
[UpdatedDate] [datetime] NULL CONSTRAINT [DF__DimBrowse__Updat__615D519E] DEFAULT (getdate())
)
GO
ALTER TABLE [email].[DimBrowser] ADD CONSTRAINT [PK__DimBrows__748199885DD59194] PRIMARY KEY CLUSTERED  ([DimBrowserId])
GO
