CREATE TABLE [zzz].[archive__TM_AltId_20170516]
(
[acct_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[alt_acct_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[alt_id_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[alt_id_type_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[alt_id_comment] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NULL
)
GO
CREATE CLUSTERED INDEX [CIX_Archive_TM_AltId] ON [zzz].[archive__TM_AltId_20170516] ([acct_id])
GO
