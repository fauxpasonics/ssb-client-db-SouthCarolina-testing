CREATE TABLE [zzz].[ods__TM_AltId_20170516]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[acct_id] [int] NULL,
[alt_acct_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[alt_id_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[alt_id_type_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[alt_id_comment] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsertDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HashKey] [binary] (32) NULL
)
GO
ALTER TABLE [zzz].[ods__TM_AltId_20170516] ADD CONSTRAINT [PK__TM_AltId__3213E83FC213CFBA] PRIMARY KEY CLUSTERED  ([id])
GO
CREATE NONCLUSTERED INDEX [IDX_acct_id] ON [zzz].[ods__TM_AltId_20170516] ([acct_id])
GO
