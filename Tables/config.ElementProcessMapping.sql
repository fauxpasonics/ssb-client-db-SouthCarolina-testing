CREATE TABLE [config].[ElementProcessMapping]
(
[ElementProcessId] [int] NOT NULL IDENTITY(1, 1),
[ElementId] [int] NULL,
[ProcessId] [int] NULL,
[DateCreated] [date] NULL CONSTRAINT [DF__ElementPr__DateC__7EB8AA5B] DEFAULT (getdate()),
[DateUpdated] [date] NULL CONSTRAINT [DF__ElementPr__DateU__7FACCE94] DEFAULT (getdate()),
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__ElementPr__Creat__00A0F2CD] DEFAULT (suser_sname()),
[UpdatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__ElementPr__Updat__01951706] DEFAULT (suser_sname())
)
GO
