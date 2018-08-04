CREATE TABLE [zzz].[archive__TM_Attend_20170516]
(
[acct_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[event_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[section_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[row_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[seat_num] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[scan_date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[scan_time] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[gate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[barcode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NULL CONSTRAINT [DF__TM_Attend__Creat__17C286CF] DEFAULT (getdate())
)
GO
CREATE CLUSTERED INDEX [CIX_Archive_TM_Attend] ON [zzz].[archive__TM_Attend_20170516] ([acct_id])
GO
CREATE NONCLUSTERED INDEX [IDX_CreatedDate] ON [zzz].[archive__TM_Attend_20170516] ([CreatedDate])
GO
CREATE NONCLUSTERED INDEX [IDX_SourceFileName] ON [zzz].[archive__TM_Attend_20170516] ([SourceFileName])
GO
