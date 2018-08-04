CREATE TABLE [email].[DimOperatingSystem]
(
[DimOperatingSystemId] [int] NOT NULL IDENTITY(-2, 1),
[OperatingSystem] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__DimOperat__Creat__00D5FCF7] DEFAULT (user_name()),
[CreatedDate] [datetime] NULL CONSTRAINT [DF__DimOperat__Creat__01CA2130] DEFAULT (getdate()),
[UpdatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__DimOperat__Updat__02BE4569] DEFAULT (user_name()),
[UpdatedDate] [datetime] NULL CONSTRAINT [DF__DimOperat__Updat__03B269A2] DEFAULT (getdate())
)
GO
ALTER TABLE [email].[DimOperatingSystem] ADD CONSTRAINT [PK__DimOpera__04A7A4C680E11FA5] PRIMARY KEY CLUSTERED  ([DimOperatingSystemId])
GO
