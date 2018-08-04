CREATE TABLE [zzz].[ods__TM_CustTrace_20170516]
(
[seq_id] [int] NULL,
[acct_id] [int] NULL,
[full_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[activity_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[call_reason] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[call_reason_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[error_desc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ip_address] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[add_user] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[add_datetime] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cust_name_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[activity_comment] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsertDate] [datetime] NULL CONSTRAINT [DF__TM_CustTr__Inser__72910220] DEFAULT (getdate()),
[UpdateDate] [datetime] NULL CONSTRAINT [DF__TM_CustTr__Updat__73852659] DEFAULT (getdate()),
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HashKey] [binary] (32) NULL,
[id] [int] NOT NULL IDENTITY(1, 1)
)
GO
ALTER TABLE [zzz].[ods__TM_CustTrace_20170516] ADD CONSTRAINT [PK_TM_CustTrace] PRIMARY KEY CLUSTERED  ([id])
GO
CREATE NONCLUSTERED INDEX [IDX_acct_id] ON [zzz].[ods__TM_CustTrace_20170516] ([acct_id])
GO
CREATE NONCLUSTERED INDEX [IDX_activity_name] ON [zzz].[ods__TM_CustTrace_20170516] ([activity_name])
GO
CREATE NONCLUSTERED INDEX [IDX_call_reason] ON [zzz].[ods__TM_CustTrace_20170516] ([call_reason])
GO
CREATE NONCLUSTERED INDEX [IDX_cust_name_id] ON [zzz].[ods__TM_CustTrace_20170516] ([cust_name_id])
GO
CREATE NONCLUSTERED INDEX [IDX_seq_id] ON [zzz].[ods__TM_CustTrace_20170516] ([seq_id])
GO
