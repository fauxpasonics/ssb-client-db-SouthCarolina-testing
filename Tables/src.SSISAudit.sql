CREATE TABLE [src].[SSISAudit]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[ssisRunUser] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ssisRunDate] [datetime] NULL CONSTRAINT [DF__SSISAudit__ssisR__19AACF41] DEFAULT (getdate())
)
GO
ALTER TABLE [src].[SSISAudit] ADD CONSTRAINT [PK__SSISAudi__3213E83F84E61E74] PRIMARY KEY CLUSTERED  ([id])
GO
