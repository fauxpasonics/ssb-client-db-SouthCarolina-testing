CREATE TABLE [src].[TMAPI_AttendanceResult]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NULL CONSTRAINT [DF__TMAPI_Att__ETL_C__6DCC4D03] DEFAULT (getdate()),
[event_code] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[event_id] [int] NULL,
[section_id] [int] NULL,
[row_id] [int] NULL,
[seat_num] [int] NULL,
[acct_id] [int] NULL,
[plan_event_id] [int] NULL,
[bc_event_id] [int] NULL,
[barcode] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[seat_code] [int] NULL,
[print_count] [int] NULL,
[ticket_type] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[scan_type] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[result_code] [int] NULL,
[action_time] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[gate] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[am_record_id] [int] NULL,
[price_code] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[comp] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[result_type] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[valid] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ticket_acct_id] [int] NULL,
[source_system] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[channel_ind] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[number_of_records] [int] NULL,
[results_per_page] [int] NULL
)
GO
ALTER TABLE [src].[TMAPI_AttendanceResult] ADD CONSTRAINT [PK__TMAPI_At__7EF6BFCDA7899027] PRIMARY KEY CLUSTERED  ([ETL_ID])
GO
