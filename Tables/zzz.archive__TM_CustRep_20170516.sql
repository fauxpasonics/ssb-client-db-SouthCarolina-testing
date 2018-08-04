CREATE TABLE [zzz].[archive__TM_CustRep_20170516]
(
[acct_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[acct_rep_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[acct_rep_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[acct_rep_type_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rep_cust_name_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rep_name_first] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rep_name_middle] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rep_name_last] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rep_name_title] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rep_company_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rep_nick_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rep_name_last_first_mi] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rep_full_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rep_user_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rep_email_addr] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rep_phone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rep_phone_formatted] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NULL CONSTRAINT [DF__TM_CustRe__Creat__7B264821] DEFAULT (getdate())
)
GO
CREATE CLUSTERED INDEX [CIX_Archive_TM_CustRep] ON [zzz].[archive__TM_CustRep_20170516] ([acct_id])
GO
CREATE NONCLUSTERED INDEX [IDX_CreatedDate] ON [zzz].[archive__TM_CustRep_20170516] ([CreatedDate])
GO
CREATE NONCLUSTERED INDEX [IDX_SourceFileName] ON [zzz].[archive__TM_CustRep_20170516] ([SourceFileName])
GO
