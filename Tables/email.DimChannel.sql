CREATE TABLE [email].[DimChannel]
(
[DimChannelId] [int] NOT NULL IDENTITY(-2, 1),
[Channel] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__DimChanne__Creat__6FAB70F5] DEFAULT (user_name()),
[CreatedDate] [datetime] NULL CONSTRAINT [DF__DimChanne__Creat__709F952E] DEFAULT (getdate()),
[UpdatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__DimChanne__Updat__7193B967] DEFAULT (user_name()),
[UpdatedDate] [datetime] NULL CONSTRAINT [DF__DimChanne__Updat__7287DDA0] DEFAULT (getdate())
)
GO
ALTER TABLE [email].[DimChannel] ADD CONSTRAINT [PK__DimChann__37F5D04D7BFB8641] PRIMARY KEY CLUSTERED  ([DimChannelId])
GO
