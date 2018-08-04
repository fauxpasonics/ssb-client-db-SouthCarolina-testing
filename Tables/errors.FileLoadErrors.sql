CREATE TABLE [errors].[FileLoadErrors]
(
[FileName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FlatFileSourceErrorOutputColumn] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorCode] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorColumn] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
