CREATE TABLE [zzz].[ods__TM_ListCode_20170516]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[acct_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[value] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sort_seq] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsertDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HashKey] [binary] (32) NULL
)
GO
ALTER TABLE [zzz].[ods__TM_ListCode_20170516] ADD CONSTRAINT [PK__TM_ListC__3213E83FB1F3DD65] PRIMARY KEY CLUSTERED  ([id])
GO
