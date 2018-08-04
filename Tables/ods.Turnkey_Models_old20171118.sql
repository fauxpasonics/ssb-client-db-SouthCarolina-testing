CREATE TABLE [ods].[Turnkey_Models_old20171118]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_UpdatedDate] [datetime] NOT NULL,
[ETL_IsDeleted] [bit] NOT NULL,
[ETL_DeletedDate] [datetime] NULL,
[ETL_DeltaHashKey] [binary] (32) NULL,
[ETL_FileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PersonID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Priority] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriorityDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GroupPriority] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GroupPriorityDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TicketingSystemAccountID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AbilitecID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sport] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
