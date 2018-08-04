CREATE TABLE [ods].[Turnkey_Models]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__Turnkey_M__ETL_C__525575CF] DEFAULT (getdate()),
[ETL_UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF__Turnkey_M__ETL_U__53499A08] DEFAULT (getdate()),
[ETL_IsDeleted] [bit] NOT NULL CONSTRAINT [DF__Turnkey_M__ETL_I__543DBE41] DEFAULT ((0)),
[ETL_DeletedDate] [datetime] NULL,
[ETL_DeltaHashKey] [binary] (32) NULL,
[ETL_FileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PersonID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FootballPriority] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FootballPriorityDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AbilitecID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TicketingSystemAccountID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [ods].[Turnkey_Models] ADD CONSTRAINT [PK__Turnkey___7EF6BFCD91E6635A] PRIMARY KEY CLUSTERED  ([ETL_ID])
GO
