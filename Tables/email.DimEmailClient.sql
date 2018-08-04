CREATE TABLE [email].[DimEmailClient]
(
[DimEmailClientId] [int] NOT NULL IDENTITY(-2, 1),
[EmailClient] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__DimEmailC__Creat__7B1D23A1] DEFAULT (user_name()),
[CreatedDate] [datetime] NULL CONSTRAINT [DF__DimEmailC__Creat__7C1147DA] DEFAULT (getdate()),
[UpdatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__DimEmailC__Updat__7D056C13] DEFAULT (user_name()),
[UpdatedDate] [datetime] NULL CONSTRAINT [DF__DimEmailC__Updat__7DF9904C] DEFAULT (getdate())
)
GO
ALTER TABLE [email].[DimEmailClient] ADD CONSTRAINT [PK__DimEmail__92D90F91D22CAE91] PRIMARY KEY CLUSTERED  ([DimEmailClientId])
GO
