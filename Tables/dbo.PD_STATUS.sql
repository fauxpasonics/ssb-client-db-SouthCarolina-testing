CREATE TABLE [dbo].[PD_STATUS]
(
[ETLSID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[STATUS] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[NAME] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LAST_USER] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[LAST_DATETIME] [datetime] NULL,
[ZID] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SOURCE_ID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EXPORT_DATETIME] [datetime] NULL
)
GO
ALTER TABLE [dbo].[PD_STATUS] ADD CONSTRAINT [PK_PD_STATUS] PRIMARY KEY CLUSTERED  ([ETLSID], [STATUS])
GO
