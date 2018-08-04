CREATE TABLE [zzz].[archive__TM_ListCode_20170516]
(
[acct_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[value] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sort_seq] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NULL
)
GO
CREATE CLUSTERED INDEX [CIX_Archive_TM_ListCode] ON [zzz].[archive__TM_ListCode_20170516] ([acct_id])
GO
CREATE NONCLUSTERED INDEX [IDX_CreatedDate] ON [zzz].[archive__TM_ListCode_20170516] ([CreatedDate])
GO
