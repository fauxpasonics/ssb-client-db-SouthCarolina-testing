CREATE TABLE [zzz].[ods__TM_Attend_20170516]
(
[id] [bigint] NOT NULL IDENTITY(1, 1),
[acct_id] [bigint] NULL,
[event_id] [int] NULL,
[section_id] [int] NULL,
[row_id] [int] NULL,
[seat_num] [int] NULL,
[scan_date] [datetime] NULL,
[scan_time] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[gate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[barcode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsertDate] [datetime] NULL CONSTRAINT [DF__TM_Attend__Inser__1CF15040] DEFAULT (getdate()),
[UpdateDate] [datetime] NULL CONSTRAINT [DF__TM_Attend__Updat__1DE57479] DEFAULT (getdate()),
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HashKey] [binary] (32) NULL
)
GO
ALTER TABLE [zzz].[ods__TM_Attend_20170516] ADD CONSTRAINT [PK__TM_Atten__3213E83FA32B787A] PRIMARY KEY CLUSTERED  ([id])
GO
