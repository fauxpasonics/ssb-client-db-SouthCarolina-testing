CREATE TABLE [etl].[EventLog]
(
[LogId] [bigint] NOT NULL IDENTITY(1, 1),
[BatchId] [bigint] NOT NULL,
[EventLevel] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EventSource] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EventCategory] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LogEvent] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LogMessage] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EventDate] [datetime] NOT NULL CONSTRAINT [DF__EventLog__EventD__1367E606] DEFAULT (getdate()),
[ExecutionId] [uniqueidentifier] NOT NULL CONSTRAINT [DF__EventLog__Execut__145C0A3F] DEFAULT (newid()),
[UserName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SourceSystem] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
ALTER TABLE [etl].[EventLog] ADD CONSTRAINT [PK_EventLog] PRIMARY KEY CLUSTERED  ([LogId])
GO
