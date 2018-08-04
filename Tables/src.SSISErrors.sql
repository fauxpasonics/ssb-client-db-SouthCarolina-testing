CREATE TABLE [src].[SSISErrors]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[ssisError] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ssisErrorCode] [int] NULL,
[ssisErrorColumn] [int] NULL
)
GO
ALTER TABLE [src].[SSISErrors] ADD CONSTRAINT [PK__SSISErro__3213E83F01480A34] PRIMARY KEY CLUSTERED  ([id])
GO
