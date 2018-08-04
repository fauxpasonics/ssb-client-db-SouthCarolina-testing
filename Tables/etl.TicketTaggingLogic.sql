CREATE TABLE [etl].[TicketTaggingLogic]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[DimSeasonID] [int] NULL,
[TagType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TagTypeTable] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TagTypeTableID] [int] NULL,
[Logic] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__CreatedDate] [datetime] NULL CONSTRAINT [DF__TicketTag__ETL____6397726F] DEFAULT (getdate()),
[ETL__UpdatedDate] [datetime] NULL CONSTRAINT [DF__TicketTag__ETL____648B96A8] DEFAULT (getdate())
)
GO
