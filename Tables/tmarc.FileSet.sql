CREATE TABLE [tmarc].[FileSet]
(
[ETL__ID] [int] NOT NULL IDENTITY(1, 1),
[FullName] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NAME] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileSize] [bigint] NULL,
[DataSet] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ArcYear] [decimal] (10, 2) NULL,
[FileRowCount] [int] NULL,
[Staged] [bit] NULL,
[Staged2] [bit] NULL,
[LoadedOds] [bit] NULL
)
GO
ALTER TABLE [tmarc].[FileSet] ADD CONSTRAINT [PK__FileSet__C4EA2445E222089A] PRIMARY KEY CLUSTERED  ([ETL__ID])
GO
