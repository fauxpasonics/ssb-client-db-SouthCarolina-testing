CREATE TABLE [etl].[ConfigTmApiRequests_bkp_20170516]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ApiDataSetName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ApiCheckResultName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ApiRequestMethod] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ApiRequestSize] [int] NULL,
[DbStageTableName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OdsLoadProcedure] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NULL,
[CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NULL,
[UpdatedDate] [datetime] NULL
)
GO
ALTER TABLE [etl].[ConfigTmApiRequests_bkp_20170516] ADD CONSTRAINT [PK__ConfigTm__3214EC07CB7F07D3] PRIMARY KEY CLUSTERED  ([Id])
GO
