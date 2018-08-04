CREATE TABLE [rpt].[GCGivingLevels]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[FundType] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GivingLevelName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MinDonation] [decimal] (18, 6) NULL,
[MaxDonation] [decimal] (18, 6) NULL,
[FundAbbreviation] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DriveYear] [int] NULL,
[Priority] [int] NULL
)
GO
