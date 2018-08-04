CREATE TABLE [zzz].[ods__TM_PaySchdPayment_20170516]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[payment_Schedule_id] [int] NULL,
[payment_number] [int] NULL,
[due_date] [datetime] NULL,
[percent_due] [decimal] (18, 6) NULL,
[payment_description] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsertDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HashKey] [binary] (32) NULL
)
GO
ALTER TABLE [zzz].[ods__TM_PaySchdPayment_20170516] ADD CONSTRAINT [PK__TM_PaySc__3213E83FC893998C] PRIMARY KEY CLUSTERED  ([id])
GO
